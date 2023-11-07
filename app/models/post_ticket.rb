class PostTicket < ApplicationRecord
  belongs_to :user

  # フォームで入力されたデータが正しいかどうか確認
  validates :festival_name, presence: true
  validates :event_name, presence: true
  validates :category, presence: true
  validates :content, presence: true
  validates :event_date, presence: true
  validates :venue, presence: true
  validates :price, presence: true, numericality: true
  validates :count, presence: true, numericality: true
  validates :unit, presence: true
  
  # 画像の保存(Railsに標準で備わっている機能)
  has_one_attached :image

  # post_ticket（親）からpurchasing_quantities（子）を取得
  has_many :purchasing_quantities, dependent: :destroy
  has_many :ticket_inquiries, dependent: :destroy
  has_many :ticket_buyer_limiteds, dependent: :destroy

end
