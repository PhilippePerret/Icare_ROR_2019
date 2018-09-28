class ActionWatcher < ApplicationRecord

  # Peuvent être transmis à la création de l'objet, et transformés avant
  # la validation.
  attr_accessor :at, :in, :objet, :path

  # Pour définir à la volée le sujet du mail qui sera envoyé
  attr_accessor :subject

  belongs_to :user

  before_validation :amenage_data
  after_validation  :raise_en_cas_derreur

  after_create :send_mails_if_any

  validates :user_id, presence: true, allow_nil: true
  validates :action_watcher_path, presence: true, length: {minimum: 6}, on: :create

  # Pour jouer l'action-watcher
  def run
    load_required
    execute
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


  # ========= LES PATHS UTILES ==============

  # Le dossier principal de l'action-watcher
  def folder
    @folder ||= File.join(Rails.root,'lib','action_watchers',action_watcher_path)
  end
  def before_mail_admin ; @before_mail_admin  ||= render_if_exist('before_mailto_admin')  end
  def before_mail_user  ; @before_mail_user   ||= render_if_exist('before_mailto_user')   end
  def after_mail_admin  ; @after_mail_admin   ||= render_if_exist('after_mailto_admin')   end
  def after_mail_user   ; @after_mail_user    ||= render_if_exist('after_mailto_user')    end
  def render_if_exist(relative_path)
    relative_path.concat('.html.erb')
    full_path = File.join(folder,relative_path)
    if File.exist?(full_path)
      [ERB.new(File.read(full_path)).result(binding), self.subject]
    end
  end

  private


    def send_mails_if_any
      unless before_mail_admin.nil?
        # => Il faut envoyer le mail à l'administrateur
        ActionWatcherMailer.send_to_admin(self, *before_mail_admin).deliver_now
      end
      unless before_mail_user.nil?
        # => Il faut envoyer le mail à l'user
        puts "Je dois envoyer un mail à l'user"
      end
    end

    # Méthode appelée avant la validation (et donc l'enregistrement), pour transformer
    # certaines valeurs qui ont pu être transmises différemment.
    # Notamment :
    #   * la propriété :triggered_at peut être transmise par :at ou :in
    #   * :model et :model_id peuvent être transmis par :objet, l'instance de l'objet
    #     à suivre.
    #   * :path pour action_watcher_path
    def amenage_data

      # Model et ID du model transmis par :objet
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
      if path
        self.action_watcher_path = path
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


end
