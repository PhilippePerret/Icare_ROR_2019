class AbsModule < ActiveRecord::Base

  validates :titre, presence: true
  validates :dim, presence: true

  validates :short_description, presence: true
end
