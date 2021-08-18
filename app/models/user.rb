class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_save :downcase_email
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  mount_uploader :avatar, UseravatarUploader

  # フォロー関連
  # rubocop:disable Rails/InverseOf
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  # rubocop:enable Rails/InverseOf
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  # ユーザーフォロー関連メソッド
  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  # パスワード入力なしで自身のユーザー情報を変更可能に（devise）
  def update_without_current_password(params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update(params)
    clean_up_passwords
    result
  end

  # ゲストユーザー機能用
  def self.guest
    find_or_create_by!(email: 'guestuser@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲストユーザー'
    end
  end

  # いいね済か確認
  def like?(post)
    like_posts.include?(post)
  end
  
  def own?(object)
    id == object.user_id
  end

  # ユーザー名での絞り込み
  scope :searched, -> (search){ where(['name Like ?', "%#{search}%"]) }

  private
    def downcase_email
      self.email = email.downcase
    end


end
