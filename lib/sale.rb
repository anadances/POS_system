class Sale < ActiveRecord::Base
  has_many :purchases
  has_many :products, through: :purchases
  belongs_to :cashier
end