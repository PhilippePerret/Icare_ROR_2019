class IcModule < ApplicationRecord

  belongs_to  :abs_module
  belongs_to  :user
  has_one     :ic_etape, as: :current_etape
  has_many    :ic_etapes

  # has_many    :documents, through :ic_etapes
  # has_many    :paiements
  # has_many :pauses
  
end
