class IcDocument < ApplicationRecord

  belongs_to :ic_etape
  has_one_attached :original
  has_one_attached :comments


  # Retourne true si l'ic-document a un commentaire
  def comments?
    self.comments.attached?
  end
  alias :commented? :comments?


  # Indiquent que le document original et/ou commentaires existe
  def set_original_exists
    set_option(:original, 0, 1)
  end
  def set_comments_exists
    set_option(:comments, 0, 1, dont_save = true)
    update_columns(
      comments_options: self.comments_options,
      commented_at:     Time.now
    )
  end

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

  def set_option which, bit, value, dont_save = false
    koptions = "#{which}_options".to_sym
    opts = send(koptions) || '0'*8
    opts[bit] = value.to_s
    self.send("#{koptions}=".to_sym, opts)
    update_attribute(koptions, opts) unless dont_save
  end

end
