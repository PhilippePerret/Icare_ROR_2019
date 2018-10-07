class IcDocument < ApplicationRecord

  belongs_to :ic_etape
  has_one_attached :original
  has_one_attached :comments


  # Raccourcis
  def ic_module
    @ic_module ||= ic_etape.ic_module
  end
  def user
    @user ||= ic_module.user
  end

  # ---------------------------------------------------------------------
  #   Méthodes d'action sur les fichiers

  # Enregistre le fichier commentaire dans un fichier temporaire
  def save_comments_in_tmpfile
    File.unlink(comments_tmppath) if File.exist?(comments_tmppath)
    File.open(comments_tmppath,'wb'){|f| f.write(self.comments.download)}
    return comments_tmppath
  end
  def save_original_in_tmpfile
    File.unlink(original_tmppath) if File.exist?(original_tmppath)
    File.open(original_tmppath,'wb'){|f| f.write(self.original.download)}
    return original_tmppath
  end

  # ---------------------------------------------------------------------
  #   Méthodes d'état

  # Retourne true si l'ic-document a un commentaire
  def comments?
    self.comments.attached? || option(:comments, 0) == 1
  end
  alias :commented? :comments?

  # Retourne true si le document +which+ existe et est partagé
  def shared?(which)
    option(which, 1) == 1
  end

  # Retourne true si au moins le document original a été déposé sur le
  # Quai des docs
  def on_qdd?
    option(:original, 3) == 1
  end

  # ---------------------------------------------------------------------
  # Méthode d'options

  def set_option which, bit, value, dont_save = false
    opts = options(which)
    opts[bit] = value.to_s
    self.send("#{koptions(which)}=".to_sym, opts)
    update_attribute(koptions(which), opts) unless dont_save
  end
  def save_options
    update_attributes(
      comments_options: self.comments_options,
      original_options: self.original_options
    )
  end
  # Retourne l'option du document +which+ (original ou comments) pour le bit
  # +bit+ (0-start)
  def option(which, bit)
    options(which)[bit].to_i
  end

  # Indiquent que le document original et/ou commentaires existe
  def set_original_exists
    set_option(:original, 0, 1)
  end
  def set_comments_exists
    set_option(:comments, 0, 1, dont_save = true)
    update_attributes(
      comments_options: self.comments_options,
      commented_at:     Time.now
    )
  end

  # Méthode appelée quand on partage tous les documents
  def share_all
    share(:original, dont_save = true)
    share(:comments, dont_save = true) if commented?
    save_options
  end
  def share which, dont_save = false
    set_option(which, 1, 1, dont_save)
  end
  def dont_share(which, dont_save = false)
    set_option(which, 1, 2, dont_save)
  end

  # ---------------------------------------------------------------------
  #   Méthodes de path

  def qdd_path(which)
    @qdd_paths ||= Hash.new
    @qdd_paths[which] ||= Rails.root.join('public','qdd',qdd_name(which))
  end
  def qdd_name(which)
    "#{affixe_qdd}#{which == :comments ? '_comsPhil' : ''}.pdf"
  end
  # Affiche des documents pour le quai des documents
  def affixe_qdd
    @affixe_qdd ||= begin
      '%{mod_dim}-M%{mod_id}-E%{etp_num}-U%{uid}-%{id}' % {
        mod_id:   ic_module.abs_module.id,
        mod_dim:  ic_module.abs_module.dim,
        etp_num:  ic_etape.abs_etape.numero,
        uid:      user.id,
        id:       self.id
      }
    end
  end

  def original_tmppath
    @original_tmppath ||= Rails.root.join('tmp', original_name)
  end
  def comments_tmppath
    @comments_tmppath ||= Rails.root.join('tmp',comments_tmpname)
  end
  def comments_tmpname
    @comments_tmpname ||= "#{original_affixe}_comsPhil.pdf"
  end
  def original_affixe
    @original_affixe ||= File.basename(original_name, File.extname(original_name))
  end

  def options(which)
    opts = send(koptions(which)) || '0'*8
  end
  def koptions(which)
    case which
    when :original then @koptions_original ||= :original_options
    when :comments then @koptions_comments ||= :comments_options
    end
  end

end
