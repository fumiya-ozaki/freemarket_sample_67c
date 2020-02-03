class Address < ApplicationRecord
  belongs_to :user, optional: true
  validates :post_code, :prefecture, :city, :block, :last_name, :first_name, :last_name_kana, :first_name_kana ,presence: true
end
