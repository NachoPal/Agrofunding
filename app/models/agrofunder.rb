class Agrofunder < User

has_many :fundings
has_many :farmlands, through: :fundings
	
end
