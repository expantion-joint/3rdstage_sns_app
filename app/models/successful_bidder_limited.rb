class SuccessfulBidderLimited < ApplicationRecord
  belongs_to :post

  # 未入力防止
  validates :set_time, presence: true
  validates :set_location, presence: true
  validates :suspension, presence: true
  validates :message, presence: true
  validates :contact_address, presence: true

end
