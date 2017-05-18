class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  validates :username, presence: true
  validates_uniqueness_of :username
	after_create :assign_default_role, :assign_elo

  def admin?
    has_role?(:admin)
  end

  def assign_default_role
    self.add_role(:player) if self.roles.blank?
  end

  def assign_elo
    self.elo = 1500;
    self.save
  end

end
