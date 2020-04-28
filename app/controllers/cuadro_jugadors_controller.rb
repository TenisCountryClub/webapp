class CuadroJugadorsController < ApplicationController
  before_action :get_categorium, :get_torneo
  before_action :set_cuadro_jugador, only: [:show, :edit, :update, :destroy]

  # GET /cuadro_jugadors
  # GET /cuadro_jugadors.json
  def index
    @cuadros= @categorium.cuadros.order(:id)
  end

  # GET /cuadro_jugadors/1
  # GET /cuadro_jugadors/1.json
  def show
  end

  # GET /cuadro_jugadors/new
  def new
    @cuadro_jugador = CuadroJugador.new
  end

  # GET /cuadro_jugadors/1/edit
  def edit
  end

  # POST /cuadro_jugadors
  # POST /cuadro_jugadors.json
  def create
    @cuadro_jugador = CuadroJugador.new(cuadro_jugador_params)

    respond_to do |format|
      if @cuadro_jugador.save
        format.html { redirect_to @cuadro_jugador, notice: 'Cuadro jugador was successfully created.' }
        format.json { render :show, status: :created, location: @cuadro_jugador }
      else
        format.html { render :new }
        format.json { render json: @cuadro_jugador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cuadro_jugadors/1
  # PATCH/PUT /cuadro_jugadors/1.json
  def update
    respond_to do |format|
      if @cuadro_jugador.update(cuadro_jugador_params)
        format.html { redirect_to @cuadro_jugador, notice: 'Cuadro jugador was successfully updated.' }
        format.json { render :show, status: :ok, location: @cuadro_jugador }
      else
        format.html { render :edit }
        format.json { render json: @cuadro_jugador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuadro_jugadors/1
  # DELETE /cuadro_jugadors/1.json
  def destroy
    @cuadro_jugador.destroy
    respond_to do |format|
      format.html { redirect_to cuadro_jugadors_url, notice: 'Cuadro jugador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_torneo
      @torneo= Torneo.find(params[:torneo_id])
    end
    def get_categorium
      @categorium= Categorium.find(params[:categorium_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_cuadro_jugador
      @cuadro_jugador = CuadroJugador.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cuadro_jugador_params
      params.require(:cuadro_jugador).permit(:cuadro_id, :jugador_id, :numero)
    end
end
