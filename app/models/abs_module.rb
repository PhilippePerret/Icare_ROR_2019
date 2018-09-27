class AbsModule < ActiveRecord::Base

  has_many  :abs_etapes
  has_many  :ic_modules

  # = VALIDATIONS =
  validates :name, presence: true
  validates :dim, presence: true

  validates :short_description, presence: true
  validates :long_description, presence: true

end
