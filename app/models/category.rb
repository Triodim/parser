class Category < ActiveRecord::Base
  validates :url, uniqueness: true

  has_many :products
end
