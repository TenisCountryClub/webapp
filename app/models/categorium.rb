class Categorium < ApplicationRecord

	has_many :cuadros, dependent: :destroy
	has_many :grupos, dependent: :destroy
	has_many :jugadors, dependent: :destroy
  belongs_to :torneo
  before_save :set_numero_jugadores
  after_commit :crear_grupos_cuadros

  	validates :nombre, presence: {message: "no puede estar vacío"}
	validates :numero_grupos,:numero_jugadores_grupo, presence: {message: "no puede estar vacío"}, if: :es_roundRobin?
	validates :numero_jugadores, presence: {message: "no puede estar vacío"}, if: :es_cuadroAvance?
	validates :numero_jugadores, numericality: {only_integer: true, message: "no puede ser otra cosa que un entero"},if: :es_cuadroAvance?
	validates :numero_grupos,:numero_jugadores_grupo,  numericality: {only_integer: true, message: "no puede ser otra cosa que un entero"}, if: :es_roundRobin?
	validate :es_potencia_de_dos
	validate :cuadra_grupos_cuadros

	def cuadra_grupos_cuadros
		if numero_grupos
			x=numero_grupos*2
			if (x != 0) && ((x & (x - 1)) == 0)
			else
				errors.add(:numero_grupos, "debe ser potencia de dos")
			end
		end
	end

	def set_numero_jugadores
		if es_roundRobin?
			self.numero_jugadores= self.numero_grupos*self.numero_jugadores_grupo
		end
	end


	def es_potencia_de_dos
		if tipo== "cuadroAvance" and numero_jugadores
			x=numero_jugadores
	    	if (x != 0) && ((x & (x - 1)) == 0)
	    	else
	    		errors.add(:numero_jugadores, "debe ser potencia de dos")
	    	end
	    	if numero_jugadores<2
	    		errors.add(:numero_jugadores, "debe mayor o igual a dos")
	    	end
	    end
	end
  def crear_grupos_cuadros
		puts "hola"
		if self.tipo=="cuadroAvance"
			self.cuadros.destroy_all
			self.grupos.destroy_all
			aux=self.numero_jugadores/2
			while aux>=1
				i=1
				puts "hola"
				while i<=aux
					cuadro=Cuadro.new
					case aux
					when 64
						cuadro.set_etapa("64vos de final")
					when 32
						cuadro.set_etapa("32vos de final")
					when 16
						cuadro.set_etapa("16vos de final")
					when 8
						cuadro.set_etapa("8vos de final")
					when 4
						cuadro.set_etapa("4tos de final")
					when 2
						cuadro.set_etapa("semifinal")
					when 1
						cuadro.set_etapa("Final")
					end
					cuadro.categorium=self
					cuadro.set_numero(i)
					cuadro.save
					i+=1
				end
				aux/=2
			end
		elsif self.tipo=="roundRobin"
			self.grupos.destroy_all
			self.cuadros.destroy_all
			i=1
			nombre="Grupo A"
			while i<=self.numero_grupos
				puts "Categorium id"+self.id.to_s
				grupo=Grupo.new
				grupo.categorium=self
				grupo.set_numero(i)
				grupo.set_nombre(nombre)
				grupo.save
				i+=1
				nombre[-1]=nombre[-1].next
				puts "hola1"
			end
			aux= self.numero_grupos
			while aux>=1
				i=1
				puts aux.to_s
				while i<=aux
					cuadro=Cuadro.new
					case aux
					when 64
						cuadro.set_etapa("64vos de final")
					when 32
						cuadro.set_etapa("32vos de final")
					when 16
						cuadro.set_etapa("16vos de final")
					when 8
						cuadro.set_etapa("8vos de final")
					when 4
						cuadro.set_etapa("4tos de final")
					when 2
						cuadro.set_etapa("Semifinal")
					when 1
						cuadro.set_etapa("Final")
					end
					cuadro.categorium=self
					cuadro.set_numero(i)
					cuadro.save
					i+=1
					puts i.to_s
				end
				aux/=2
			end
		end
	end

	def es_roundRobin?
		tipo=="roundRobin"
	end
	def es_cuadroAvance?
		tipo=="cuadroAvance"
	end

	def sortear_cuadroAvance(categorium_id)
		jugadores= Jugador.where(categorium_id: categorium_id).order(:ranking).to_a
		categorium = Categorium.find(categorium_id)
		categorium.cuadros.each do |cuadro|
			if jugadores.length>0
				cuadro_jugador1=CuadroJugador.new
				cuadro_jugador1.cuadro= cuadro
				aleatorio=rand(0..(jugadores.length-1))
				cuadro_jugador1.jugador= jugadores[aleatorio]
				cuadro_jugador1.numero=1
				jugadores.delete_at(aleatorio)
				cuadro_jugador1.save
			end
			if jugadores.length>0
				cuadro_jugador2=CuadroJugador.new
				cuadro_jugador2.cuadro= cuadro
				aleatorio=rand(0..(jugadores.length-1))
				cuadro_jugador2.jugador= jugadores[aleatorio]
				cuadro_jugador2.numero=2
				jugadores.delete_at(aleatorio)
				cuadro_jugador2.save
			end
		end
	end

	def sortear_roundRobin(categorium_id)
		jugadores= Jugador.where(categorium_id: categorium_id).order(:ranking).to_a
		categorium = Categorium.find(categorium_id)
		categorium.grupos.each do |grupo|
			i=0
			while i<4
				if jugadores.length>0
					puts "hola"
					grupo_jugador= GrupoJugador.new
					grupo_jugador.grupo=grupo
					aleatorio=rand(0..(jugadores.length-1))
					grupo_jugador.jugador=jugadores[aleatorio]
					grupo_jugador.numero=i+1
					jugadores.delete_at(aleatorio)
					grupo_jugador.save					
				end
				i+=1
			end
		end
	end

	def sortear_categoria
		if self.tipo=="cuadroAvance"
			sortear_cuadroAvance(self.id)
		elsif self.tipo=="roundRobin"
			sortear_roundRobin(self.id)
		end
	end
end
