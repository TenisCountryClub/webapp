class Categorium < ApplicationRecord

	has_many :cuadros, dependent: :destroy
	has_many :grupos, dependent: :destroy
	has_many :jugadors, dependent: :destroy
	has_many :cuadro_jugadors, through: :cuadros
	has_many :grupo_jugadors, through: :grupos
	has_many :partidos, -> { joins(:grupo, :cuadro) }, class_name: 'Partido'
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
			ronda=1
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
					cuadro.ronda= ronda
					cuadro.save
					i+=1
				end
				ronda+=1
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
			if self.numero_jugadores_grupo==3 or self.numero_jugadores_grupo==4
				ronda=4
			elsif self.numero_jugadores_grupo==5
				ronda=6
			end
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
					cuadro.ronda= ronda
					cuadro.save
					i+=1
					puts i.to_s
				end
				ronda+=1
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

	def sortear_cuadroAvance(categorium_id, jugadores)
		categorium = Categorium.find(categorium_id)
		categorium.cuadros.each do |cuadro|
			if jugadores.length>0 and cuadro.cuadro_jugadors.where(numero: 1).empty?
				cuadro_jugador1=CuadroJugador.new
				cuadro_jugador1.cuadro= cuadro
				aleatorio=rand(0..(jugadores.length-1))
				cuadro_jugador1.jugador= jugadores[aleatorio]
				cuadro_jugador1.numero=1
				jugadores.delete_at(aleatorio)
				cuadro_jugador1.save
			end
			if jugadores.length>0 and cuadro.cuadro_jugadors.where(numero: 2).empty?
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
		jugadores= Jugador.where(categorium_id: categorium_id).order(:ranking)
		siembras= jugadores.first(jugadores.length/4)
		no_siembras=jugadores.last(jugadores.length-jugadores.length/4)
		categorium = Categorium.find(categorium_id)
		i=0
		categorium.grupos.each do |grupo|
			grupo_jugador= GrupoJugador.new
			grupo_jugador.grupo=grupo
			grupo_jugador.jugador=siembras[i]
			grupo_jugador.numero=1
			grupo_jugador.save
			i+=1
		end
		categorium.grupos.each do |grupo|
			i=0
			while i<4
				if no_siembras.length>0 and grupo.grupo_jugadors.where(numero: i+1).empty?
					puts "hola"
					grupo_jugador= GrupoJugador.new
					grupo_jugador.grupo=grupo
					aleatorio=rand(0..(no_siembras.length-1))
					grupo_jugador.jugador=no_siembras[aleatorio]
					grupo_jugador.numero=i+1
					no_siembras.delete_at(aleatorio)
					grupo_jugador.save					
				end
				i+=1
			end
		end
	end

	def crear_cuadro_jugador(etapa,numero_cuadro,numero,siembra, categorium, numero_siembra)
		cuadro_jugador=CuadroJugador.new
		cuadro_jugador.cuadro=categorium.cuadros.where(etapa: etapa).where(numero: numero_cuadro).first
		cuadro_jugador.jugador=siembra
		cuadro_jugador.numero=numero
		cuadro_jugador.numero_siembra=numero_siembra
		cuadro_jugador.save
	end

	def insertar_siembra_64(siembra,numero_siembra,categorium)
		case numero_siembra
		when 1
			crear_cuadro_jugador("32vos de final",1,1,siembra,categorium,numero_siembra)
		when 2
			crear_cuadro_jugador("32vos de final",32,2,siembra,categorium,numero_siembra)
		when 3
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",9,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",24,2,siembra,categorium,numero_siembra)
			end
		when 4
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 9).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",9,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",24,2,siembra,categorium,numero_siembra)
			end
		when 5
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",16,2,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",17,1,siembra,categorium,numero_siembra)
			end
		when 6
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 16).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",16,2,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",17,1,siembra,categorium,numero_siembra)
			end
		when 7
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",5,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",28,2,siembra,categorium,numero_siembra)
			end
		when 8
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 5).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",5,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",28,2,siembra,categorium,numero_siembra)
			end	
		when 9
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",13,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",20,2,siembra,categorium,numero_siembra)
			end
		when 10
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 13).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",13,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",20,2,siembra,categorium,numero_siembra)
			end	
		when 11
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",3,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",30,2,siembra,categorium,numero_siembra)
			end
		when 12
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 3).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",3,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",30,2,siembra,categorium,numero_siembra)
			end
		when 13
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",7,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",26,2,siembra,categorium,numero_siembra)
			end	
		when 14
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 7).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",7,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",26,2,siembra,categorium,numero_siembra)
			end
		when 15
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",11,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",22,2,siembra, categorium, numero_siembra)
			end	
		when 16
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 11).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("32vos de final",11,1,siembra,categorium,numero_siembra)
			else
				crear_cuadro_jugador("32vos de final",22,2,siembra,categorium,numero_siembra)
			end		
		end
	end

	def insertar_siembra_32(siembra,numero_siembra,categorium)
		case numero_siembra
		when 1
			crear_cuadro_jugador("16vos de final",1,1,siembra, categorium, numero_siembra)
		when 2
			crear_cuadro_jugador("16vos de final",16,2,siembra, categorium, numero_siembra)
		when 3
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",5,1,siembra, categorium, numero_siembra)
			else
				crear_cuadro_jugador("16vos de final",12,2,siembra, categorium, numero_siembra)
			end
		when 4
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 5).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("16vos de final",5,1,siembra, categorium, numero_siembra)
			else
				crear_cuadro_jugador("16vos de final",12,2,siembra, categorium, numero_siembra)
			end
		when 5
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",8,2,siembra, categorium, numero_siembra)
			else
				crear_cuadro_jugador("16vos de final",9,1,siembra, categorium, numero_siembra)
			end
		when 6
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 8).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("16vos de final",8,2,siembra, categorium, numero_siembra)
			else
				crear_cuadro_jugador("16vos de final",9,1,siembra, categorium, numero_siembra)
			end
		when 7
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",3,1,siembra, categorium, numero_siembra)
			else
				crear_cuadro_jugador("16vos de final",14,2,siembra, categorium, numero_siembra)
			end
		when 8
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 3).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("16vos de final",3,1,siembra, categorium, numero_siembra)
			else
				crear_cuadro_jugador("16vos de final",14,2,siembra, categorium, numero_siembra)
			end
		end
	end	

	def insertar_siembra_16(siembra,numero_siembra,categorium)
		case numero_siembra
		when 1
			crear_cuadro_jugador("8vos de final",1,1,siembra, categorium,numero_siembra)
		when 2
			crear_cuadro_jugador("8vos de final",8,2,siembra, categorium,numero_siembra)
		when 3
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("8vos de final",3,1,siembra, categorium,numero_siembra)
			else
				crear_cuadro_jugador("8vos de final",6,2,siembra, categorium,numero_siembra)
			end
		when 4
			if categorium.cuadros.where(etapa: "8vos de final").where(numero: 3).first.cuadro_jugadors.empty?
				crear_cuadro_jugador("8vos de final",3,1,siembra, categorium,numero_siembra)
			else
				crear_cuadro_jugador("8vos de final",6,2,siembra, categorium,numero_siembra)
			end
		end
	end

	def insertar_siembra_8(siembra,numero_siembra,categorium)
		case numero_siembra
		when 1
			crear_cuadro_jugador("4tos de final",1,1,siembra, categorium,numero_siembra)
		when 2
			crear_cuadro_jugador("4tos de final",4,2,siembra, categorium,numero_siembra)
		end
	end
	def insertar_siembra_4(siembra,numero_siembra,categorium)
		case numero_siembra
		when 1
			cuadro_jugador=CuadroJugador.new
			cuadro_jugador.cuadro=categorium.cuadros.where(etapa: "Semifinal").where(numero: 1).first
			cuadro_jugador.jugador=siembra
			cuadro_jugador.numero=1
			cuadro_jugador.numero_siembra=numero_siembra
			cuadro_jugador.save
		end
	end

	def insertar_bye_4(bye,numero_bye,categorium)
		case numero_bye
			when 1
				crear_cuadro_jugador("Semifinal",1,2,bye, categorium,numero_siembra)
			end	
	end

	def insertar_bye_8(bye,numero_bye,categorium)
		case numero_bye
			when 1
				crear_cuadro_jugador("4tos de final",1,2,bye, categorium,numero_siembra)
			when 2
				crear_cuadro_jugador("4tos de final",4,1,bye, categorium,numero_siembra)
			end	
	end

	def insertar_bye_16(bye,numero_bye,categorium)
		case numero_bye
		when 1
			crear_cuadro_jugador("8vos de final",1,2,bye, categorium,nil)
		when 2
			crear_cuadro_jugador("8vos de final",8,1,bye, categorium,nil)
		when 3
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("8vos de final",3,2,bye, categorium,nil)
			else
				crear_cuadro_jugador("8vos de final",6,1,bye, categorium,nil)
			end
		when 4
			if categorium.cuadros.where(etapa: "8vos de final").where(numero: 3).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("8vos de final",3,2,bye, categorium,nil)
			else
				crear_cuadro_jugador("8vos de final",6,1,bye, categorium,nil)
			end
		when 5
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("8vos de final",4,1,bye, categorium,nil)
			else
				crear_cuadro_jugador("8vos de final",5,2,bye, categorium,nil)
			end
		when 6
			if categorium.cuadros.where(etapa: "8vos de final").where(numero: 3).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("8vos de final",4,1,bye, categorium,nil)
			else
				crear_cuadro_jugador("8vos de final",5,2,bye, categorium,nil)
			end
		when 7
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("8vos de final",2,2,bye, categorium,nil)
			else
				crear_cuadro_jugador("8vos de final",7,1,bye, categorium,nil)
			end
		end
	end

	def insertar_bye_32(bye,numero_bye,categorium)
		case numero_bye
		when 1
			crear_cuadro_jugador("16vos de final",1,2,bye, categorium, nil)
		when 2
			crear_cuadro_jugador("16vos de final",16,1,bye, categorium, nil)
		when 3
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",5,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",12,1,bye, categorium, nil)
			end
		when 4
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 5).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("16vos de final",5,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",12,1,bye, categorium, nil)
			end
		when 5
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",8,1,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",9,2,bye, categorium, nil)
			end
		when 6
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 8).first.cuadro_jugadors.where(numero: 1).empty?
				crear_cuadro_jugador("16vos de final",8,1,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",9,2,bye, categorium, nil)
			end
		when 7
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",3,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",14,1,bye, categorium, nil)
			end
		when 8
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 3).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("16vos de final",3,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",14,1,bye, categorium, nil)
			end
		when 9
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",7,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",10,1,bye, categorium, nil)
			end
		when 10
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 7).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("16vos de final",7,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",10,1,bye, categorium, nil)
			end
		when 11
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",2,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",15,1,bye, categorium, nil)
			end
		when 12
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 2).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("16vos de final",2,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",15,1,bye, categorium, nil)
			end
		when 13
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",4,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",13,1,bye, categorium, nil)
			end
		when 14
			if categorium.cuadros.where(etapa: "16vos de final").where(numero: 4).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("16vos de final",4,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",13,1,bye, categorium, nil)
			end
		when 15
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("16vos de final",6,2,bye, categorium, nil)
			else
				crear_cuadro_jugador("16vos de final",11,1,bye, categorium, nil)
			end
		end
	end	

	def insertar_bye_64(bye,numero_bye,categorium)
		case numero_bye
		when 1
			crear_cuadro_jugador("32vos de final",1,2,bye,categorium,nil)
		when 2
			crear_cuadro_jugador("32vos de final",32,1,bye,categorium,nil)
		when 3
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",9,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",24,1,bye,categorium,nil)
			end
		when 4
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 9).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",9,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",24,1,bye,categorium,nil)
			end
		when 5
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",16,1,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",17,2,bye,categorium,nil)
			end
		when 6
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 16).first.cuadro_jugadors.where(numero: 1).empty?
				crear_cuadro_jugador("32vos de final",16,1,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",17,2,bye,categorium,nil)
			end
		when 7
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",5,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",28,1,bye,categorium,nil)
			end
		when 8
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 5).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",5,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",28,1,bye,categorium,nil)
			end	
		when 9
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",13,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",20,1,bye,categorium,nil)
			end
		when 10
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 13).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",13,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",20,1,bye,categorium,nil)
			end	
		when 11
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",3,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",30,1,bye,categorium,nil)
			end
		when 12
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 3).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",3,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",30,1,bye,categorium,nil)
			end
		when 13
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",7,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",26,1,bye,categorium,nil)
			end	
		when 14
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 7).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",7,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",26,1,bye,categorium,nil)
			end
		when 15
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",11,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",22,1,bye, categorium, nil)
			end	
		when 16
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 11).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",11,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",22,1,bye,categorium,nil)
			end
		when 17
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",15,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",18,1,bye, categorium, nil)
			end	
		when 18
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 15).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",15,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",18,1,bye,categorium,nil)
			end	
		when 19
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",2,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",31,1,bye, categorium, nil)
			end	
		when 20
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 2).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",2,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",31,1,bye,categorium,nil)
			end
		when 21
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",4,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",29,1,bye, categorium, nil)
			end	
		when 22
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 4).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",4,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",29,1,bye,categorium,nil)
			end	
		when 23
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",6,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",27,1,bye, categorium, nil)
			end	
		when 24
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 6).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",6,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",27,1,bye,categorium,nil)
			end	
		when 25
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",8,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",25,1,bye, categorium, nil)
			end
		when 26
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 8).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",8,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",25,1,bye,categorium,nil)
			end	
		when 27
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",10,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",23,1,bye, categorium, nil)
			end	
		when 28
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 10).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",10,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",23,1,bye,categorium,nil)
			end	
		when 29
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",12,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",21,1,bye, categorium, nil)
			end	
		when 30
			if categorium.cuadros.where(etapa: "32vos de final").where(numero: 12).first.cuadro_jugadors.where(numero: 2).empty?
				crear_cuadro_jugador("32vos de final",12,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",21,1,bye,categorium,nil)
			end	
		when 31
			cuadrante= rand(1..2)
			if cuadrante==1
				crear_cuadro_jugador("32vos de final",14,2,bye,categorium,nil)
			else
				crear_cuadro_jugador("32vos de final",19,1,bye, categorium, nil)
			end					
		end
	end
	def insertar_siembra(siembra,numero_siembra,numero_jugadores,categorium)
		case numero_jugadores
		when 4
			insertar_siembra_4(siembra,numero_siembra,categorium)
		when 8
			insertar_siembra_8(siembra,numero_siembra,categorium)
		when 16
			insertar_siembra_16(siembra,numero_siembra,categorium)
		when 32
			insertar_siembra_32(siembra,numero_siembra,categorium)
		when 64
			insertar_siembra_64(siembra,numero_siembra,categorium)
		end	
	end

	def insertar_bye(bye, numero_bye, numero_jugadores, categorium)
		case numero_jugadores
		when 4
			insertar_bye_4(bye,numero_bye,categorium)
		when 8
			insertar_bye_8(bye,numero_bye, categorium)
		when 16
			insertar_bye_16(bye,numero_bye, categorium)
		when 32
			insertar_bye_32(bye,numero_bye, categorium)
		when 64
			insertar_bye_64(bye,numero_bye, categorium)
		end	
	end

	def sortear_categoria
		jugadores=Jugador.where(categorium_id: self.id).order(ranking: :asc)
		if jugadores.length%4 == 0
			numero_siembras=jugadores.length/4
		else
			numero_siembras=jugadores.length/4+1
		end
		siembras= jugadores.first(numero_siembras)
		siembras= siembras.to_a
		i=1
		no_siembras=jugadores.last(jugadores.length-numero_siembras)
		if self.tipo=="cuadroAvance"
			siembras.each do |siembra|
	  			insertar_siembra(siembra,i,self.numero_jugadores,self)
	  			i+=1
			end
		end
		numero_byes= self.numero_jugadores-jugadores.length
		if self.tipo=="cuadroAvance"
			for i in 1..numero_byes do
			  insertar_bye(Jugador.where(nombre: "BYE").first,i, self.numero_jugadores,self)
			end
		end
		
		if self.tipo=="cuadroAvance"
			sortear_cuadroAvance(self.id,no_siembras.to_a)
		elsif self.tipo=="roundRobin"
			sortear_roundRobin(self.id)
		end
	end

	#¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡GENERAR HORARIOS!!!!!!!!!!!!!!!!!!!!!!

	def partidos1
		partidos = Partido.none
		if self.tipo=="roundRobin"
			return self.partidos
		else
			return self.partidos
		end
	end

	def partidos_de_categoria(partidos)
		res_partidos=Partido.none
		partidos.each do |partido|
			if partido.cuadro != nil		
				if partido.cuadro.categorium==self
					res_partidos=res_partidos.or(Partido.where(id: partido.id))
					#puts res_partidos
				end
			else
				if partido.grupo.categorium==self
					res_partidos=res_partidos.or(Partido.where(id: partido.id))
					#puts res_partidos
				end
			end
		end
		puts res_partidos
		res_partidos=res_partidos.order(numero: :asc)
	end

	#¡FALTAN CASOS!
	def ronda_torneo_adecuada(partido,hora,partidos_posteriores)
		if partido==0
			ronda_torneo = RondaTorneo.new
			ronda_torneo.setter(1,self.torneo.numero_canchas,hora)
		else
			quedan_canchas_en_ronda=partido.torneo.quedan_canchas_en_ronda?(partido)
			if partidos_posteriores.empty?
				if quedan_canchas_en_ronda[:bool]
					ronda_torneo= partido.ronda_torneo
				else
					ronda_torneo = RondaTorneo.new
					ronda_torneo.setter(partido.ronda_torneo.numero + 1, partido.torneo.numero_canchas,hora)
				end
			else
				if quedan_canchas_en_ronda[:bool]
					ronda_torneo=partido.ronda_torneo
				else
					ronda_torneo=partidos_posteriores.first.ronda_torneo
				end
			end
		end
		return ronda_torneo
	end

	def numero_cancha_adecuada(partido)
		if partido == 0
			puts "CEEEEEEEEEEEEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOOO"
			return 1
		else
			quedan_canchas_en_ronda= partido.torneo.quedan_canchas_en_ronda?(partido)
			if quedan_canchas_en_ronda[:bool]
				return quedan_canchas_en_ronda[:cancha]
			else
				return 1
			end
		end
	end

	def hora_inicio_adecuada(partido)
		if partido == 0
			return self.torneo.fecha_inicio.to_datetime.change({hour: 8, min: 0, sec: 0})
		else
			quedan_canchas_en_ronda= partido.torneo.quedan_canchas_en_ronda?(partido)
			if quedan_canchas_en_ronda[:bool]
				return partido.hora_inicio
			else
				return partido.hora_inicio + 45.minutes
			end
		end
	end

	def ronda_adecuada(categorium, partidos)
		if categorium.partidos_de_categoria(partidos).empty?
			return 1
		else
			return categorium.partidos_de_categoria(partidos).last.ronda+1
		end
	end

	def numero_adecuado(partido)
		if partido == 0
			return 1
		else
			return partido.numero + 1
		end
	end

	def numero_max_rondas_fase_grupo(categorium)
=begin
		grupo= categorium.grupos.order(numero_jugadores: :desc).first		
		if grupo.numero_jugadores==3 or grupo.numero_jugadores==4
			numero_rondas_grupo=3
		elsif grupo.numero_jugadore== 5
			numero_rondas_grupo= 5
		end	
=end
		if categorium.numero_jugadores_grupo==3 or categorium.numero_jugadores_grupo==4
			numero_rondas_grupo=3
		elsif categorium.numero_jugadores_grupo== 5
			numero_rondas_grupo= 5
		end
	end

	def numero_partido(partido)
		if partido == 0
			return 0
		else
			return partido.numero
		end
	end

	def generar_ronda_round_robin(partido_previo,hora)
		partidos = self.torneo.partidos
		ronda = ronda_adecuada(self, partidos) 
		partidos_posteriores = partidos.where("numero > ?",numero_partido(partido_previo))
		contador=0
		if ronda <= numero_max_rondas_fase_grupo(self)
			self.grupos.each do |grupo|
				case self.numero_jugadores_grupo
				when 3
					case ronda
					when 1
						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, grupo.grupo_jugadors.where(numero: 3).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

					when 2

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 3).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 3

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 2).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 3).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					end
				when 4
					case ronda
					when 1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 4).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, grupo.grupo_jugadors.where(numero: 3).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 2

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 3).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, grupo.grupo_jugadors.where(numero: 4).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 3

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 2).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 3).last.jugador, grupo.grupo_jugadors.where(numero: 4).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					end
				when 5
					case ronda
					when 1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 4).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, grupo.grupo_jugadors.where(numero: 3).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 5).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 2

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 3).last.jugador, grupo.grupo_jugadors.where(numero: 1).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 4).last.jugador, grupo.grupo_jugadors.where(numero: 5).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 3

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 5).last.jugador, grupo.grupo_jugadors.where(numero: 3).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, grupo.grupo_jugadors.where(numero: 2).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 4).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 4

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 2).last.jugador, grupo.grupo_jugadors.where(numero: 5).last.jugador,hora,ronda,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 3).last.jugador, grupo.grupo_jugadors.where(numero: 4).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 1).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					when 5
						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 4).last.jugador, grupo.grupo_jugadors.where(numero: 2).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 5).last.jugador, grupo.grupo_jugadors.where(numero: 1).last.jugador,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1

						cancha = numero_cancha_adecuada(partido_previo)
						hora = hora_inicio_adecuada(partido_previo)
						numero = numero_adecuado(partido_previo)
						ronda_torneo = ronda_torneo_adecuada(partido_previo)
						partido_previo = Partido.new
						partido_previo.setter(grupo.grupo_jugadors.where(numero: 3).last.jugador, Jugador.where(nombre: "BYE").last,hora,ronda,cancha,grupo,nil,numero,ronda_torneo)
						contador+=1
					end
				end
			end
		else
			self.cuadros.where(ronda: ronda).order(numero: :asc).each do |cuadro|
				cancha = numero_cancha_adecuada(partido_previo)
				hora = hora_inicio_adecuada(partido_previo)
				numero = numero_adecuado(partido_previo)
				ronda_torneo = ronda_torneo_adecuada(partido_previo)
				partido_previo = Partido.new
				partido_previo.setter(nil, nil,hora,ronda,cancha,nil,cuadro,numero,ronda_torneo)
				contador+=1
			end
		end
		return contador
	end

	def generar_ronda_cuadro_avance(partido_previo)
		partidos = self.torneo.partidos
		ronda = ronda_adecuada(self, partidos)
		contador = 0 
		partidos_posteriores = partidos.where("numero > ?",numero_partido(partido_previo))
		self.cuadros.where(ronda: ronda).order(numero: :asc).each do |cuadro|
			cancha = numero_cancha_adecuada(partido_previo)
			hora = hora_inicio_adecuada(partido_previo)
			numero = numero_adecuado(partido_previo)
			ronda_torneo = ronda_torneo_adecuada(partido_previo,hora)
			partido_previo = Partido.new
			partido_previo.setter(nil, nil,hora,ronda,cancha,nil,cuadro,numero,ronda_torneo)
			contador+=1
		end
		 return contador
	end
end
