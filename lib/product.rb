class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :price, presence: true
  validates :type, presence: true
  has_many :purchases
  has_many :sales, through: :purchases
end