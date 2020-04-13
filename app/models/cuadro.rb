class Cuadro < ApplicationRecord
  belongs_to :categorium

  validates :numero, :etapa, :categorium_id, presence: true
  validates :numero,  numericality: {only_integer: true}

   def set_etapa(valor)
  	 write_attribute(:etapa, valor)
  	puts "hola2"
  end

    def set_numero(valor)
  	 write_attribute(:numero, valor)
  	 puts "hola2"
  	end

  	def etapa
  		self[:etapa]
  	end

  	def numero
  		self[:numero]
  	end
end
