class Article < ApplicationRecord
  validates :url, uniqueness: true, presence: true
end
