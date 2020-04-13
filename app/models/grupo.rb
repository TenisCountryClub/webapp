class Grupo < ApplicationRecord
  belongs_to :categorium

  def set_numero(valor)
	 write_attribute(:numero, valor)
	 puts "hola2"
	end

	def set_nombre(valor)
		write_attribute(:nombre, valor)
	end

	def set_categorium(categoria)
		write_attribute(:categorium, categoria)
	end

	def nombre
		self[:nombre]
	end

	def numero
		self[:numero]
	end
end
