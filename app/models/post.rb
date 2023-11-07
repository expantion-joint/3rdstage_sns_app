class Post < ApplicationRecord
  
  # userテーブルを参照する
  belongs_to :user
  
  # フォームで入力されたデータが正しいかどうか確認
  validates :festival_name, presence: true
  validates :event_name, presence: true
  validates :category, presence: true
  validates :content, presence: true
  validates :event_date, presence: true, date_in_future: true, on: :create
  validates :venue, presence: true
  validates :start_time, presence: true, date_in_future: true, on: :create
  validates :end_time, presence: true, date_in_future: true ,start_end_date: { start_date_attribute: :start_time, event_date_attribute: :event_date }, on: :create
  validates :start_price, presence: true, numericality: true
  validates :count, presence: true, numericality: true
  
  # 画像の保存(Railsに標準で備わっている機能)
  has_one_attached :image

  # post（親）からbid（子）を取得
  # dependent: :destroyを記載することでコメント全て削除可能となる
  has_many :bids, dependent: :destroy
  has_many :successful_bidder_limiteds, dependent: :destroy
  has_many :event_inquiries, dependent: :destroy
  has_many :hammers, dependent: :destroy
  
end
