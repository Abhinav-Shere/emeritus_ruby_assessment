class User < ApplicationRecord
  has_many :enrollments_as_student, class_name: 'Enrollment', foreign_key: :user_id
  has_many :enrollments_as_teacher, class_name: 'Enrollment', foreign_key: :teacher_id
  has_many :favorite_teacher_enrollments, -> { where(favorite: true) }, class_name: 'Enrollment', foreign_key: :user_id
  belongs_to :user, class_name: 'User', optional: true

  enum kind: { student: 0, teacher: 1, student_teacher: 2 }

  validates :kind, exclusion: { in: %w[student], if: :teaching? }
  validates :kind, exclusion: { in: %w[teacher], if: :studying? }

  def teaching?
    kind == 'teacher' && enrollments_as_teacher.any?
  end

  def studying?
    kind == 'student' && enrollments_as_student.any?
  end

	def self.classmates(user)
    user_enrollments = Enrollment.where(user_id: user.id).pluck(:program_id)
    classmates_ids = Enrollment.where(program_id: user_enrollments).where.not(user_id: user.id).pluck(:user_id).uniq
    User.where(id: classmates_ids)
  end
end
