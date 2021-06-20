class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :url, uniqueness: true, presence: true
end
