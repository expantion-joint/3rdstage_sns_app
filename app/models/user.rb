class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 未入力防止
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :display_name, presence: true
  # validates :postcode, presence: true
  # validates :prefecture_code, presence: true
  # validates :address_city, presence: true
  # validates :address_street, presence: true
  # validates :birthday, presence: true
  # validates :financial_institution, length: { is: 4 }, numericality: { only_integer: true }
  # validates :branch_name, length: { is: 3 }, numericality: { only_integer: true }

  # 画像の保存(Railsに標準で備わっている機能)
  has_one_attached :image
  
  # user（親）からpost（子）を取得
  # dependent: :destroyを記載することでコメント全て削除可能となる
  has_many :posts, dependent: :destroy
  has_many :successful_bidder_limited, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :event_inquiries, dependent: :destroy
  has_many :hammers, dependent: :destroy
  has_many :post_tickets, dependent: :destroy
  has_many :purchasing_quantities, dependent: :destroy
  has_many :ticket_inquiries, dependent: :destroy
  
end
