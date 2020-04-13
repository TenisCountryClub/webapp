class JugadorsController < ApplicationController
  skip_before_action :verify_authenticity_token, except: [:create, :update, :destroy]

  before_action :set_jugador, only: [:show, :edit, :update, :destroy, :asociar_jugador]

  def asociar_jugador
    @jugador.categorium_id=jugador_categoria_params[:categorium_id]
    puts "CATID"+jugador_categoria_params.to_s
    puts "CATEGORIUM"+@jugador.categorium_id.to_s
    if @jugador.save
    redirect_to jugadors_url
    end    
  end

  # GET /jugadors
  # GET /jugadors.json
  def index
    @jugadors = Jugador.order(:id)
    @categorias=Array.new
    categ=Categorium.all
    categ.each do |categorium|
      @categorias.push({"Nombre"=>categorium.torneo.nombre+" - "+categorium.nombre, "id" =>categorium.id})
    end
  end

  # GET /jugadors/1
  # GET /jugadors/1.json
  def show
  end

  # GET /jugadors/new
  def new
    @jugador = Jugador.new
  end

  # GET /jugadors/1/edit
  def edit
  end

  # POST /jugadors
  # POST /jugadors.json
  def create
    @jugador = Jugador.new(jugador_params)

    respond_to do |format|
      if @jugador.save
        format.html { redirect_to @jugador, notice: 'Jugador was successfully created.' }
        format.json { render :show, status: :created, location: @jugador }
      else
        format.html { render :new }
        format.json { render json: @jugador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jugadors/1
  # PATCH/PUT /jugadors/1.json
  def update
    respond_to do |format|
      if @jugador.update(jugador_params)
        format.html { redirect_to @jugador, notice: 'Jugador was successfully updated.' }
        format.json { render :show, status: :ok, location: @jugador }
      else
        format.html { render :edit }
        format.json { render json: @jugador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jugadors/1
  # DELETE /jugadors/1.json
  def destroy
    @jugador.destroy
    respond_to do |format|
      format.html { redirect_to jugadors_url, notice: 'Jugador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jugador
      @jugador = Jugador.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jugador_params
      params.require(:jugador).permit(:numero, :nombre, :ranking, :edad, :club_asociacion, :fecha_inscripcion, :status)
    end

    def jugador_categoria_params
      params.require(:jugador).permit(:categorium_id)
    end
end
