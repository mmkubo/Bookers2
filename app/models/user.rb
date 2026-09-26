class User < ApplicationRecord

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  #フォローされる時,自分はfollowed_id側
  has_many :passive_relationships, class_name:"Relationship", 
            foreign_key:"followed_id", dependent: :destroy
  #フォロワー(follower_id側)を呼び出す
  has_many :followers, through: :passive_relationships, source: :follower

  #フォローする時,自分はfollower_id側
  has_many :active_relationships, class_name:"Relationship", 
            foreign_key:"follower_id", dependent: :destroy
  #フォロー中の人(followed_id側)を呼び出す
  has_many :followings, through: :active_relationships, source: :followed

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_one_attached :profile_image

  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/noimage_user.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [100, 100]).processed
  end

  # すでにいいねしているか判定する
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

# 相手をフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
# フォローを解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end
# すでにフォローしているか判定する
  def following?(other_user)
    active_relationships.exists?(followed_id: other_user.id)
  end

  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

end
