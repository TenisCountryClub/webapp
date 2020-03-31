class Llave < ApplicationRecord
  attr_accessor :etapa, :numero
  belongs_to :torneo

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
