# Pour pouvoir les utiliser tout de suite dans les notifications, il faut
# que je mette ça ici.
require Rails.root.join('app','helpers','html_string')

class ActionWatcher < ApplicationRecord

  # Pour pouvoir utiliser les méthodes d'helper dans les notifications et autres
  # mail (tout ce qui peut être utilisé dans les views)
  # ainsi que les helpers d'application
  include ApplicationHelper
  include ActionView::Helpers::DateHelper
  def helpers
    ActionController::Base.helpers
  end


  # Pour enregistrer l'erreur fatale si elle se produit.
  attr_accessor :fatal_error

  # Peuvent être transmis à la création de l'objet, et transformés avant
  # la validation.
  attr_accessor :at, :in
  attr_writer   :objet

  # Méthode définissant la classe du LI principal contenant la notification
  # cette méthode sera surclassée par la méthode définie dans l'action_watcher.rb
  def notification_type(cuser)
    'simple-notice'
  end

  # Méthodes d'helper directes
  # note : "directes" signifie que ce sont des propriétés de l'action-watcher,
  # pas des méthodes d'helper où il faudrait envoyer l'instance

  def form_url
    "/action_watchers/#{self.id}/run"
  end

  # Pour pouvoir rediriger vers une autre page (par exemple pour le paiement
  # ou pour un téléchargement)
  attr_reader :redirection
  def redirect_to redirection
    @redirection = redirection
    @need_to_be_redirected = true
  end
  def redirect?
    !!@need_to_be_redirected
  end

  # Propriétés volatiles utiles
  # Noter qu'à la création, :objet a pu être transmis à l'instance. Donc cette
  # propriété fonctionne aussi bien à la création qu'à l'exécution du watcher.
  def objet
    @objet ||= begin
      Object.const_get(model).find(model_id)
    rescue ActiveRecord::RecordNotFound => e
      raise I18n.t('activerecord.errors.models.record_not_found', {classe: model, id: model_id})
    end
  end
  # Pour connaitre l'objet (en cas d'erreur par exemple)
  def objet_designation
    "Objet de classe #{objet.class} et d'ID ##{objet.id}"
  end

  # Pour ajouter un message final de succès
  def add_success_final str
    @success_final_message ||= Array.new
    @success_final_message << str
  end
  alias :add_success_message :add_success_final
  def success_final_message
    @success_final_message.join('<br>')
  end
  # Pour ajouter un message final de succès
  def add_failure_final str
    @failure_final_message ||= Array.new
    @failure_final_message << str
  end
  alias :add_failure_message :add_failure_final
  def failure_final_message
    @failure_final_message.join('<br>')
  end

  def dont_destroy
    @do_not_destroy = true
  end
  def dont_send_mails
    @do_not_send_any_mail = true
  end

  # /---------------------------------------------------------------------

  # L'utilisateur courant (icarien ou administrateur)
  attr_accessor :current_user
  attr_accessor :params # accessorable surtout pour preview
  attr_accessor :success_message
  attr_writer :danger_message, :failure_message
  def danger_message
    @danger_message || @failure_message
  end

  # Pour quand l'instance est rechargée de la table
  def path= val ; self.action = val end
  alias :name= :path=
  def path    ; @path   ||= action end
  alias :name :path

  # Pour définir à la volée le sujet du mail qui sera envoyé
  attr_accessor :subject

  # Pour modifier le mail à utiliser
  attr_writer :mailto_admin_after_name
  attr_writer :mailto_user_after_name
  attr_writer :mailto_admin_before_name
  attr_writer :mailto_user_before_name
  def mailto_admin_after_name
    @mailto_admin_after_name ||= "mailto_admin_after.html.#{extension_mails}"
  end
  def mailto_user_after_name
    @mailto_user_after_name ||= "mailto_user_after.html.#{extension_mails}"
  end
  def mailto_admin_before_name
    @mailto_admin_before_name ||= "mailto_admin_before.html.#{extension_mails}"
  end
  def mailto_user_before_name
    @mailto_user_before_name ||= "mailto_user_before.html.#{extension_mails}"
  end
  def extension_mails
    'erb'
    # 'haml'
  end
  def extension_notifications
    'haml'
  end

  belongs_to :user

  before_validation :amenage_data
  after_validation  :raise_en_cas_derreur

  # Pour envoyer les mails après la création du watcher si nécessaire
  after_create :send_before_mails_if_any

  validates :user_id, presence: true, allow_nil: true
  validates :action, presence: true, length: {minimum: 6}, on: :create

  # Pour jouer l'action-watcher
  def run_for(cuser, params)
    @running_is_successfull = false
    self.current_user = cuser
    @params = params
    is_valid? || (return self)
    load_required
    execute
    unless interrupted?
      send_after_mails_if_any unless !!@do_not_send_any_mail
      self.destroy            unless !!@do_not_destroy
    end
    @success_final_message && self.success_message = success_final_message
    @failure_final_message && self.failure_message = failure_final_message

  rescue Exception => e
    puts "# ERREUR: #{e.message}"
    puts e.backtrace[0..5].join("\n")
    self.fatal_error      = e
    self.failure_message  = 'Une erreur est survenue. Consulter le log du serveur.'
  else
    @running_is_successfull = true # pour que aw.success? soit true
  ensure
    return self # pour le chainage
  end

  # Pour raiser (donc interrompre brutalement le watcher) en le détruisant.
  # Méthode utile pour
  def destroy_and_raise erreur = nil
    self.destroy unless !!@do_not_destroy
    if erreur.nil?
      raise
    else
      raise erreur
    end
  end

  # Retourne true si l'User +utested+ est le propriétaire de l'action-watcher
  def owner? utested
    utested == self.user
  end

  # Retourne true s'il existe une notification pour le destinataire +dest+
  # qui peut être soit le propriétaire du watcher soit l'administrateur
  # Retourne false si le watcher ne doit pas être encore triggué (cette méthode
  # est appelée juste avant l'affichage du watcher dans la liste des notifica-
  # tions)
  def notification_for?(dest = nil)
    if dest.nil?
      dest = self.current_user
    else
      self.current_user = dest
    end
    watchable_by_current? || (return false)
    load_helper # notamment pour le type de la notification
    owner?(dest) || dest.admin? || raise(I18.t('action_watchers.errors.destinataire.unknown'))
    File.exist?(notification_path(dest))
  end
  def notification_partial(dest)
    File.join(name, send("notification_#{owner?(dest) ? 'user' : 'admin'}_partial"))
  end
  def notification_path(dest)
    File.join(folder, send("notification_#{owner?(dest) ? 'user' : 'admin'}_partial") +
      ".html.#{extension_notifications}")
  end
  def notification_admin_partial
    @notification_admin_partial ||= '_notify_admin'
  end
  def notification_user_partial
    @notification_user_partial  ||= '_notify_user'
  end


  # Retourne true si la méthode `run_for` a été exécuté avec succès
  def success?
    @running_is_successfull || false
  end


  # Faut-il interrompre le programme ? Retourne TRUE si c'est le cas
  # pourra être mis à true
  def interrupted?
    !!@must_interrupt_process
  end
  def interrupt
    @must_interrupt_process = true
  end


  # ========= LES PATHS UTILES ==============

  # Le dossier principal de l'action-watcher
  def folder
    @folder ||= File.join(Rails.root,'lib','action_watchers',action)
  end
  def mail_admin_before ; @mail_admin_before  ||= rend_if_exist(mailto_admin_before_name)  end
  def mail_user_before  ; @mail_user_before   ||= rend_if_exist(mailto_user_before_name)   end
  def mail_admin_after  ; @mail_admin_after   ||= rend_if_exist(mailto_admin_after_name)   end
  def mail_user_after   ; @mail_user_after    ||= rend_if_exist(mailto_user_after_name)    end

  # ATTENTION : return [<code du message>, <sujet>]
  def rend_if_exist(relative_path)
    full_path = File.join(folder,relative_path)
    if File.exist?(full_path)
      begin
        [ ERB.new(File.read(full_path)).result(binding), self.subject ]
      rescue Exception => e
        puts e.message
        puts e.backtrace.join("\n")
      end
    end
  end

  def bind
    binding()
  end

  private


    def send_before_mails_if_any
      unless mail_admin_before.nil?
        ActionWatcherMailer.send_to_admin(self, *mail_admin_before).deliver_now
      end
      unless mail_user_before.nil?
        ActionWatcherMailer.send_to_user(self, *mail_user_before).deliver_now
      end
    end

    def send_after_mails_if_any
      unless mail_admin_after.nil?
        ActionWatcherMailer.send_to_admin(self, *mail_admin_after).deliver_now
      end
      unless mail_user_after.nil?
        ActionWatcherMailer.send_to_user(self, *mail_user_after).deliver_now
      end
    end

    # Méthode appelée avant la validation (et donc l'enregistrement), pour transformer
    # certaines valeurs qui ont pu être transmises différemment.
    # Notamment :
    #   * la propriété :triggered_at peut être transmise par :at ou :in
    #   * :model et :model_id peuvent être transmis par :objet, l'instance de l'objet
    #     à suivre.
    #   * :path pour action
    def amenage_data

      # Model et ID du model transmis par la propriété :objet
      if objet
        self.model    = objet.class.to_s
        self.model_id = objet.id
      end

      # Triggered_at
      if at
        self.triggered_at = at
      elsif self.in
        self.triggered_at = Time.now + self.in
      end

      # Action_watcher_path
      if path || name
        self.action = path || name
        self.name = action
      end
    end


    def raise_en_cas_derreur
      return if errors.empty?
      raise errors.collect{|k,m| '# %s : %s' % [k, m]}.join("\n")
    end

    # Chargement de tout le dossier
    def load_required
      Dir["#{folder}/**/*.rb"].each{|m|load m}
    end
    def load_helper
      load File.join(folder,'action_watcher_helpers.rb')
    end

    # Retourne True s'il est possible d'afficher ce watcher, c'es-à-dire s'il
    # est valide pour l'user courant et si son temps est venu.
    #
    # Il est temps si la propriété triggered_at n'est pas définie ou si elle
    # est inférieure au temps courant.
    def watchable_by_current?
      is_valid? && (triggered_at.nil? || (triggered_at < Time.now))
    end

    # Retourne TRUE si le watcher est valide
    # Il est valide si l'user courant existe et qu'il est l'user possesseur
    # du watcher ou si c'est un administrateur.
    def is_valid?
      self.current_user && (self.user == self.current_user || self.current_user.admin?)
    end


    # Renvoie true si le watcher est trop vieux.
    # Inutilisé pour le moment.
    # TODO Programmer cette méthode pour envoyer un avertissement à l'icarien
    # et/ou à l'administration
    def out_of_date?

    end

end
