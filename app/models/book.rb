class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect" #完全一致
      Book.where("title LIKE?", "#{word}")
    elsif search == "forward" #前方一致
      Book.where("title LIKE?", "#{word}%")
    elsif search == "backward" #後方一致
      Book.where("title LIKE?", "%#{word}")
    elsif search == "partial" #部分一致
      Book.where("title LIKE?", "%#{word}%")
    else
      Book.all
    end
  end

  
end
