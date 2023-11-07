class TicketBuyerLimited < ApplicationRecord
  belongs_to :post_ticket

  # 未入力防止
  validates :set_time, presence: true
  validates :set_location, presence: true
  validates :suspension, presence: true
  validates :message, presence: true
  validates :contact_address, presence: true
  
end
