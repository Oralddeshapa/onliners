class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :url, uniqueness: true, presence: true

  def valid?(context = nil)
    if self.url.include?('onliner')
      true
    else
      false
    end
  end
end
