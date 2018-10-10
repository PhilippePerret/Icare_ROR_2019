class MiniFaq < ApplicationRecord
  belongs_to :user
  belongs_to :abs_etape

  validates :question, presence: true, length: {minimum: 10, maximum: 255}, on: :create
  validates :abs_etape_id, presence: true, on: :create
  validates :user_id,  presence: true, on: :create
  
end
