require 'roo'
require 'roo-xls'



class TorneosController < ApplicationController
  before_action :set_torneo, only: [:show, :edit, :update, :destroy]

  # GET /torneos
  # GET /torneos.json
  def index
    @torneos = Torneo.all
  end

  # GET /torneos/1
  # GET /torneos/1.json
  def show
  end

  # GET /torneos/new
  def new
    @torneo = Torneo.new
  end

  # GET /torneos/1/edit
  def edit
  end

  # POST /torneos
  # POST /torneos.json
  def create
    @torneo = Torneo.new(torneo_params)



    respond_to do |format|
      if @torneo.save
        format.html { redirect_to @torneo, notice: 'Torneo was successfully created.' }
        format.json { render :show, status: :created, location: @torneo }
      else
        format.html { render :new }
        format.json { render json: @torneo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /torneos/1
  # PATCH/PUT /torneos/1.json
  def update
    respond_to do |format|
      if @torneo.update(torneo_params)
        format.html { redirect_to @torneo, notice: 'Torneo was successfully updated.' }
        format.json { render :show, status: :ok, location: @torneo }
      else
        format.html { render :edit }
        format.json { render json: @torneo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /torneos/1
  # DELETE /torneos/1.json
  def destroy
    @torneo.destroy
    respond_to do |format|
      format.html { redirect_to torneos_url, notice: 'Torneo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def obtener_jugadores
    file_path = File.join(Rails.root, "app", "controllers", "torneo1.xlsx")
    @hoja = Roo::Spreadsheet.open(file_path)
    @torneo= Hash.new 
    6.times do |i| 
        @torneo[@hoja.cell(i,1)] = @hoja.cell(i,2)
    end
    i=10
    @jugadores=[]
    while @hoja.cell(i,1).to_i!=0
      if @hoja.cell(i,1).to_i!=0
        @jugadores.append({"Nro"=>@hoja.cell(i,1),"Jugador"=>@hoja.cell(i,2),"Ranking"=>@hoja.cell(i,3),"Edad"=>@hoja.cell(i,4),"Club y Asoc."=>@hoja.cell(i,5)})
      end
      i+=1
    end
    @j=i
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_torneo
      @torneo = Torneo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def torneo_params
      params.require(:torneo).permit(:nombre, :fechaInicio, :fechaFin, :tipo)
    end
end
