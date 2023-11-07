class Bid < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :bid_price, presence: true, numericality: true

  # bid（親）からhammer（子）を取得
  # dependent: :destroyを記載することでコメント全て削除可能となる
  has_many :hammers, dependent: :destroy
end
