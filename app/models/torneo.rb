class Torneo < ApplicationRecord
	has_many :llaves
	has_many :grupos
	has_one_attached :hoja_calculo

	after_save :crear_grupos_llaves

	validates :nombre, :fechaInicio, :fechaFin,:tipo, presence: true
	validates :numero_grupos,:numero_jugadores_grupo, presence: true, if: :es_roundRobin?
	validates :numero_llaves, presence: true, if: :es_cuadroAvance?
	validate :fechaInicio_no_pasada, :fechaFin_despues_inicio
	validates :numero_llaves, numericality: {only_integer: true},if: :es_cuadroAvance?
	validates :numero_grupos,:numero_jugadores_grupo,  numericality: {only_integer: true}, if: :es_roundRobin?
	validate :es_potencia_de_dos?

	def fechaInicio_no_pasada
		if fechaInicio<Date.today
			errors.add(:fechaInicio, "no puede ser pasada")
		end
	end

	def fechaFin_despues_inicio
		if fechaFin<=fechaInicio
			errors.add(:fechaFin, "debe ser después de inicio")
		end
	end

	def es_roundRobin?
		tipo=="roundRobin"
	end
	def es_cuadroAvance?
		tipo=="cuadroAvance"
	end

	def es_potencia_de_dos?
		if numero_llaves!=nil
			x=numero_llaves
	    	if (x != 0) && ((x & (x - 1)) == 0)
	    	else
	    		errors.add(:numero_llaves, "debe ser potencia de dos")
	    	end
	    end
	end

	def crear_grupos_llaves
		puts "hola"
		if self.tipo=="cuadroAvance"
			aux=self.numero_llaves/2
			while aux>=1
				i=1
				puts "hola"
				while i<=aux
					llave=Llave.new
					case aux
					when 64
						llave.set_etapa("64vos de final")
					when 32
						llave.set_etapa("32vos de final")
					when 16
						llave.set_etapa("16vos de final")
					when 8
						llave.set_etapa("8vos de final")
					when 4
						llave.set_etapa("4tos de final")
					when 2
						llave.set_etapa("semifinal")
					when 1
						llave.set_etapa("Final")
					end
					llave.torneo=self
					llave.set_numero(i)
					llave.save
					i+=1
				end
				aux/=2
			end
		elsif self.tipo=="roundRobin"
			i=1
			while i<=self.numero_grupos
				grupo=Grupo.new
				grupo.torneo=self
				grupo.set_numero(i)
				grupo.set_numeroJugadores(self.numero_jugadores_grupo)
				grupo.save
				i+=1
				puts "hola1"
			end
			aux= self.numero_grupos
			while aux>=1
				i=1
				puts aux.to_s
				while i<=aux
					llave=Llave.new
					case aux
					when 64
						llave.set_etapa("64vos de final")
					when 32
						llave.set_etapa("32vos de final")
					when 16
						llave.set_etapa("16vos de final")
					when 8
						llave.set_etapa("8vos de final")
					when 4
						llave.set_etapa("4tos de final")
					when 2
						llave.set_etapa("Semifinal")
					when 1
						llave.set_etapa("Final")
					end
					llave.torneo=self
					llave.set_numero(i)
					llave.save
					i+=1
					puts i.to_s
				end
				aux/=2
			end
		end
	end
end	
