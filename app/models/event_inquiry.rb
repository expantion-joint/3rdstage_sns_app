class EventInquiry < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # フォームで入力されたデータが正しいかどうか確認
  validates :email, presence: true
  validates :subject, presence: true
  validates :message, presence: true
  validates :name, presence: true
  validates :contributor_email, presence: true

end
