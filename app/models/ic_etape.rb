class IcEtape < ApplicationRecord

  belongs_to  :ic_module
  belongs_to  :abs_etape

  # has_many :documents


  def user ; ic_module.user end
  
end
