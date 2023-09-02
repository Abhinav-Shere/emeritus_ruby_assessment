class Enrollment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'
  belongs_to :program

  validates :user, :teacher, :program, presence: true

  scope :favorites, -> { where(favorite: true) }
end