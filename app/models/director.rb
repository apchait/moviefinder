class Director < Personality
	has_and_belongs_to_many :movies
end
