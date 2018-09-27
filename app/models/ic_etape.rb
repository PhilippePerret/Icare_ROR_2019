class IcEtape < ApplicationRecord

  belongs_to  :ic_module
  belongs_to  :abs_etape
  belongs_to  :user, through :ic_module

  # has_many :documents

end
