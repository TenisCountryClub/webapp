class Grupo < ApplicationRecord
  belongs_to :categorium
  has_many :grupo_jugadors

  validates :numero, :nombre, :categorium_id, presence: {message: "no puede estar vacío"}
  validates :numero,  numericality: {only_integer: true, message: "no puede ser otra cosa que un entero"}


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
