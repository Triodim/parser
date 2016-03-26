class Category < ActiveRecord::Base
  validates :url, uniqueness: true

  has_and_belongs_to_many :products
end
