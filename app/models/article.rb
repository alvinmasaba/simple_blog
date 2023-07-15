class Article < ApplicationRecord
  include Visible
  
  has_many :comments, dependent: :destroy
  belongs_to :team
  has_and_belongs_to_many :tags
  
  validates :title, presence: true
  validates :body, presence: true, length: {
  minimum: 10 }

  def self.tagged_with(name)
    Tag.find_by!(name: name).articles
  end
end
