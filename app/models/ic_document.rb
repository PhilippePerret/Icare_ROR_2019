class IcDocument < ApplicationRecord

  belongs_to :ic_etape
  has_one_attached :original
  has_one_attached :comments


  # Indiquent que le document original et/ou commentaires existe
  def set_original_exists
    set_option(:original, 0, 1)
  end
  def set_comments_exists
    set_option(:comments, 0, 1)
  end

  def set_option which, bit, value
    koptions = "#{which}_options".to_sym
    opts = send(koptions) || '0'*8
    opts[bit] = value.to_s
    update_attribute(koptions, opts)
  end

end
