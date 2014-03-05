class Actor < Personality
	has_and_belongs_to_many :movies
end
