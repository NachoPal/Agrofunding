class Farmer < User

	has_many :farmlands, inverse_of: :farmer
end