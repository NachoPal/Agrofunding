class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :fundings
	has_many :farmlands, through: :fundings



	scope :farmers, -> { where(type: 'Farmer') } 
	scope :agrofunders, -> { where(type: 'Agrofunder') }

	#delegate :lions, :meerkats, :wild_boars, to: :animals
end
