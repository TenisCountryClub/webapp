class Torneo < ApplicationRecord
	include Rails.application.routes.url_helpers

	require 'roo'
	#require 'roo-xls'

	extend ActionView::Helpers::UrlHelper

	has_many :categoria

	after_create_commit :crear_jugadores
	has_one_attached :hoja_calculo

	
	
	

	validates :nombre, :fecha_inicio, :fecha_fin, presence: true
	validates :nombre, uniqueness: true
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
	          if @jugador.save!
	          	puts "GUARDADO"
	          else
	          	puts "NO GUARDADO"
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
end
