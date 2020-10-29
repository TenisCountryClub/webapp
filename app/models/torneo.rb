class Torneo < ApplicationRecord
	include Rails.application.routes.url_helpers

	require 'roo'
	#require 'roo-xls'

	extend ActionView::Helpers::UrlHelper

	has_many :categoria, dependent: :destroy

	after_create_commit :crear_jugadores
	has_one_attached :hoja_calculo

	
	
	

	validates_presence_of :nombre, :message => "no puede estar vacío"
	validates_presence_of :fecha_inicio, :message => "no puede estar vacío"
	validates_presence_of :fecha_fin, :message => "no puede estar vacío"
	validates :nombre, uniqueness: {message: "debe ser único"}
	validate :fechaInicio_no_pasada, :fechaFin_despues_inicio
	validate :es_xlsx, :presencia_adjunto


	def crear_jugadores
	      hoja = Roo::Spreadsheet.open(url_for(self.hoja_calculo))
	      i=10

	      while hoja.cell(i,1).to_i!=0 or hoja.cell(i+4,1).to_i!=0
	        if hoja.cell(i,1).to_i!=0 and hoja.cell(i,2)!=nil

	          @jugador=Jugador.new
	          @jugador.numero=hoja.cell(i,1)
	          @jugador.nombre=hoja.cell(i,2)
	          @jugador.ranking=hoja.cell(i,3)
	          @jugador.edad=hoja.cell(i,4)
	          @jugador.club_asociacion=hoja.cell(i,5)
	          @jugador.fecha_inscripcion=hoja.cell(i,6)
	          @jugador.status=hoja.cell(i,7)
	          if @jugador.save
	          	puts "GUARDADO"
	          else
	          	puts "NO GUARDADO"
	          	puts @jugador.errors.full_messages
	          end
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
		if fecha_inicio<Date.today
			errors.add(:fecha_inicio, "no puede ser pasada")
		end
	end

	def fechaFin_despues_inicio
		if fecha_fin<=fecha_inicio
			errors.add(:fecha_fin, "debe ser después de inicio")
		end
	end

	def partidos
		partidos= Partido.none
		self.categoria.each do |categorium|
			partidos=partidos.or(categorium.partidos_de_categoria(Partido.all))
		end
		return partidos.order(numero: :asc)
	end

	def ronda_torneos
		partidos= self.partidos
		rondas= Array.new
		partidos.each do |partido|
			rondas= rondas.push(partido.ronda_torneo)
		end
		return RondaTorneo.where(id: rondas.map(&:id)).order(numero: :asc)
	end

	def adelantar_rondas_por_uno(partido, partidos)
		ronda_torneo_actual=partido.ronda_torneo
		ronda_torneo_actual.numero+=1
		ronda_torneo_actual.save
		for i in partido.numero..partidos.last.numero
			ronda_torneo= partidos.where(numero: i).first.ronda_torneo
			if ronda_torneo.id != ronda_torneo_actual.id
				ronda_torneo.numero+=1
				ronda_torneo.save
				ronda_torneo_actual=ronda_torneo
			end
		end
	end

	def quedan_canchas_en_ronda?(partido)
		ronda_torneo = partido.ronda_torneo
		cancha = partido.numero_cancha
		if partido==0
			return {bool: true, cancha: 1}
		else
			if ronda_torneo.cancha_inhabilitadas.empty?
				if cancha< ronda_torneo.numero_canchas	
					return {bool: true, cancha: cancha+1}
				end
			end
		end

		ronda_torneo.cancha_inhabilitadas.each_with_index do |cancha_inhabilitada, index|
			if cancha_inhabilitada.numero_cancha > cancha
				if cancha +1 != cancha_inhabilitada.numero_cancha
					return {bool: true, cancha: cancha_inhabilitada.numero_cancha-1}
				end
				cancha = cancha_inhabilitada.numero_cancha
			end
		end
		
		return {bool: false, cancha: nil}
	end
	
	def hay_partidos_en_ronda?(partido)
		if partido.ronda_torneo.partidos.length <= 1
			return false
		else
			return true
		end		
	end

	def recorrer_partidos_derecha(ronda_torneo, cancha)
		partido_final= self.partidos.last

		if cancha> partido_final.numero_cancha and ronda_torneo== partido_final.ronda_torneo
			return
		else
			partidos_torneo = self.partidos
			partido = partidos_torneo.where(ronda_torneo: ronda_torneo).where(numero_cancha: cancha).first
			hora=partido.hora_inicio
			for i in partido.numero..partidos_torneo.last.numero
				partido_actual= partidos_torneo.where(numero: i).first
				if i+1<= partidos_torneo.last.numero
					partido_proximo= partidos_torneo.where(numero: i+1).first
					quedan_canchas = quedan_canchas_en_ronda?(partido_actual)
					if (partido_actual.ronda_torneo.hora_inicio <= partido_proximo.ronda_torneo.hora_inicio-90.minutes and partido_actual.numero_cancha == partido_actual.ronda_torneo.numero_canchas) or(partido_actual.hora_inicio <= partido_proximo.hora_inicio-90.minutes and !quedan_canchas[:bool])
						adelantar_rondas_por_uno(partido_actual,partidos)
						partido_actual.hora_inicio = partido_actual.hora_inicio+90.minutes
						partido_actual.numero_cancha=1
						ronda_torneo= RondaTorneo.new
						ronda_torneo.numero_canchas=self.numero_canchas
						ronda_torneo.numero=partido_actual.ronda_torneo.numero+1
						ronda_torneo.save
						partido_actual.ronda_torneo = ronda_torneo
						break
					else
						partido_actual.hora_inicio = partido_proximo.hora_inicio
						partido_actual.numero_cancha = partido_proximo.numero_cancha
						partido_actual.ronda_torneo = partido_proximo.ronda_torneo
						partido_actual.save
					end
				else
					quedan_canchas = quedan_canchas_en_ronda?(partido_actual)
					if partido_actual.numero_cancha == partido_actual.ronda_torneo.numero_canchas or !quedan_canchas[:bool]
						partido_actual.hora_inicio = partido_actual.hora_inicio+90.minutes
						partido_actual.numero_cancha=1
						ronda_torneo= RondaTorneo.new
						ronda_torneo.numero_canchas=self.numero_canchas
						ronda_torneo.numero=partido_actual.ronda_torneo.numero+1
						ronda_torneo.save
						partido_actual.ronda_torneo = ronda_torneo
						partido_actual.save
					else
						partido_actual.hora_inicio = partido_actual.hora_inicio
						partido_actual.numero_cancha = quedan_canchas[:cancha]
						partido_actual.ronda_torneo = partido_proximo.ronda_torneo
						partido_actual.save
					end
				end
			end
		end
	end

	def proximo_partido(cancha)
		return self.partidos.joins(:ronda_torneo).where("(ronda_torneos.numero = ? AND partidos.numero_cancha > ?) OR (ronda_torneos.numero > ?)", cancha.ronda_torneo.numero, cancha.numero_cancha, cancha.ronda_torneo.numero).order(numero: :asc).first
	end

	def partidos_en_bloque(partido,cancha_inhabilitada)
		if partido
			partidos = self.partidos.where("numero >= ?", partido.numero).order(numero: :asc)
		else
			return Partido.none
		end
		partido_aux=0
		partidos.each_with_index do |part, index|
			if index == 0 and cancha_inhabilitada.ronda_torneo.hora_inicio + 90.minutes >= part.ronda_torneo.hora_inicio
				return Partido.none
			end
			if part==partidos.last
				partido_aux= part
				break
			end
			if part.hora_inicio >= partidos[index + 1].hora_inicio - 90.minutes
				partido_aux = partidos[index + 1]
				break
			end
		end
		partidos= partidos.where("numero <= ?", partido_aux.numero).where("numero >= ?", partido.numero)
		return partidos.order(numero: :asc)
	end

	def recorrer_partidos_izquierda(cancha)
		partido = proximo_partido(cancha)
		partidos = partidos_en_bloque(partido,cancha).reverse 
		partidos.each_with_index do |partido, index|
			if index == partidos.length-1
				partido.hora_inicio = cancha.hora
				partido.numero_cancha =cancha.numero_cancha
				partido.ronda_torneo = cancha.ronda_torneo
			else
				if index == 0
					if !hay_partidos_en_ronda?(partido)
						partido.ronda_torneo.destroy
					end
				end
				partido.hora_inicio = partidos[index +  1].hora_inicio
				partido.numero_cancha = partidos[index + 1].numero_cancha
				partido.ronda_torneo = partidos[index + 1 ].ronda_torneo
			end
			partido.save
		end
	end


	def habilitar_cancha(cancha)
		self.recorrer_partidos_izquierda(cancha)
		cancha.destroy		
	end

	def inhabilitar_cancha(ronda_torneo,cancha)
		self.recorrer_partidos_derecha(ronda_torneo, cancha)
		CanchaInhabilitada.crear(cancha,ronda_torneo.hora_inicio,ronda_torneo)
	end

	def generar_ronda(categorium,partido)
		if partido != 0
			partidos_posteriores=self.partidos.where("numero > ?",partido.numero)
		else
			partidos_posteriores=self.partidos.where("numero > ?",partido)
		end
		numero_partidos = categorium.generar_ronda


	end
end
