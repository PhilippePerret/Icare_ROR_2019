class AbsEtape < ApplicationRecord
  belongs_to  :abs_module
  has_many    :ic_etapes
  
end
