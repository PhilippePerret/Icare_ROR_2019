class AbsEtape < ApplicationRecord
  belongs_to  :abs_module
  has_many    :ic_etapes
  has_many    :mini_faqs

end
