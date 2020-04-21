class GrupoJugadorsController < ApplicationController
  before_action :set_grupo_jugador, only: [:show, :edit, :update, :destroy]

  # GET /grupo_jugadors
  # GET /grupo_jugadors.json
  def index
    @grupo_jugadors = GrupoJugador.all
  end

  # GET /grupo_jugadors/1
  # GET /grupo_jugadors/1.json
  def show
  end

  # GET /grupo_jugadors/new
  def new
    @grupo_jugador = GrupoJugador.new
  end

  # GET /grupo_jugadors/1/edit
  def edit
  end

  # POST /grupo_jugadors
  # POST /grupo_jugadors.json
  def create
    @grupo_jugador = GrupoJugador.new(grupo_jugador_params)

    respond_to do |format|
      if @grupo_jugador.save
        format.html { redirect_to @grupo_jugador, notice: 'Grupo jugador was successfully created.' }
        format.json { render :show, status: :created, location: @grupo_jugador }
      else
        format.html { render :new }
        format.json { render json: @grupo_jugador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grupo_jugadors/1
  # PATCH/PUT /grupo_jugadors/1.json
  def update
    respond_to do |format|
      if @grupo_jugador.update(grupo_jugador_params)
        format.html { redirect_to @grupo_jugador, notice: 'Grupo jugador was successfully updated.' }
        format.json { render :show, status: :ok, location: @grupo_jugador }
      else
        format.html { render :edit }
        format.json { render json: @grupo_jugador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grupo_jugadors/1
  # DELETE /grupo_jugadors/1.json
  def destroy
    @grupo_jugador.destroy
    respond_to do |format|
      format.html { redirect_to grupo_jugadors_url, notice: 'Grupo jugador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grupo_jugador
      @grupo_jugador = GrupoJugador.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grupo_jugador_params
      params.require(:grupo_jugador).permit(:grupo_id, :jugador_id, :numero)
    end
end
