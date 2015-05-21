class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  
	#has_many :farmlands, as: :farmer


	
	# scope :farmers, -> { where(type: 'Farmer') } 
	# scope :agrofunders, -> { where(type: 'Agrofunder') }

	#delegate :lions, :meerkats, :wild_boars, to: :animals
end
