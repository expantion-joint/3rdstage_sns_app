class PurchasingQuantity < ApplicationRecord
  belongs_to :post_ticket
  belongs_to :user

  validates :count, presence: true, numericality: true
  
end
