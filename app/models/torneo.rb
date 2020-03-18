class Torneo < ApplicationRecord
	has_many :llaves
	has_many :grupos
end
