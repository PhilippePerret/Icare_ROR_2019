class IcDocument < ApplicationRecord

  belongs_to :ic_etape
  has_one_attached :original
  has_one_attached :comments


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

  def set_option which, bit, value, dont_save = false
    koptions = "#{which}_options".to_sym
    opts = send(koptions) || '0'*8
    opts[bit] = value.to_s
    self.send("#{koptions}=".to_sym, opts)
    update_attribute(koptions, opts) unless dont_save
  end

end
