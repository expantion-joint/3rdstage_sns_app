class Inquiry < ApplicationRecord
  belongs_to :user

  # フォームで入力されたデータが正しいかどうか確認
  validates :email, presence: true
  validates :subject, presence: true
  validates :message, presence: true
  validates :name, presence: true

end
