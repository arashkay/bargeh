class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  before_create :set_role

  def is_wizard?
    role == APP::ROLES::WIZARD
  end

  def is_hobbit?
    role == APP::ROLES::HOBBIT
  end

  def is_creature?
    role == APP::ROLES::CREATURE
  end

  def has_role?(roles=[])
    roles = [roles.to_sym] if roles.is_a? String
    roles.map{ |s| s.to_sym }.include? self.role.to_sym
  end

private
  def set_role
    self.role = APP::ROLES::CREATURE
  end

end
