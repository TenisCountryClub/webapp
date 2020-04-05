class Torneo < ApplicationRecord
	require 'roo'
	#require 'roo-xls'

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
	validate :es_potencia_de_dos
	validate :es_xlsx, :presencia_adjunto


	def crear_jugadores
	      @hoja = Roo::Spreadsheet.open(url_for(self.hoja_calculo))
	      i=10

	      while @hoja.cell(i,1).to_i!=0 or @hoja.cell(i+4,1).to_i!=0
	        if @hoja.cell(i,1).to_i!=0 and @hoja.cell(i,2)!=nil
	          @jugador=Jugador.new
	          @jugador.numero=@hoja.cell(i,1)
	          @jugador.nombre=@hoja.cell(i,2)
	          @jugador.ranking=@hoja.cell(i,3)
	          @jugador.edad=@hoja.cell(i,4)
	          @jugador.club_asociacion=@hoja.cell(i,5)
	          @jugador.fecha_inscripcion=@hoja.cell(i,6)
	          @jugador.status=@hoja.cell(i,7)
	          @jugador.save  
	        end
	        i+=1
	      end
	end

	def presencia_adjunto
		if !hoja_calculo.attached?
			errors.add(:hoja_calculo, "debe estar adjunto")
		end
	end

	def es_xlsx
		if hoja_calculo.attached? and File.extname(hoja_calculo.filename.to_s)!=".xlsx"
			errors.add(:hoja_calculo, "debe ser de formato xlsx")
		end
	end

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

	def es_potencia_de_dos
		if numero_llaves!=nil
			x=numero_llaves
	    	if (x != 0) && ((x & (x - 1)) == 0)
	    	else
	    		errors.add(:numero_llaves, "debe ser potencia de dos")
	    	end
	    	if numero_llaves<2
	    		errors.add(:numero_llaves, "debe mayor o igual a dos")
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
