class AbsModule < ActiveRecord::Base

  has_many :abs_etapes

  validates :name, presence: true
  validates :dim, presence: true

  validates :short_description, presence: true
  validates :long_description, presence: true
  
end
