class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates :username, presence: true
  validates_uniqueness_of :username
	after_create :assign_default_role
  
  def admin?
    has_role?(:admin)
  end

  def assign_default_role
    self.add_role(:player) if self.roles.blank?
  end

end
