class CuadrosController < ApplicationController
  before_action :get_torneo, :get_categorium
  before_action :set_cuadro, only: [:show, :edit, :update, :destroy]

  # GET /cuadros
  # GET /cuadros.json
  def index
    @cuadros = @categorium.cuadros
  end

  # GET /cuadros/1
  # GET /cuadros/1.json
  def show
  end

  # GET /cuadros/new
  def new
    @cuadro = Cuadro.new
  end

  # GET /cuadros/1/edit
  def edit
  end

  # POST /cuadros
  # POST /cuadros.json
  def create
    @cuadro = @categorium.cuadros.build(cuadro_params)

    respond_to do |format|
      if @cuadro.save
        format.html { redirect_to [@torneo,@categorium,@cuadro], notice: 'Cuadro fue creado exitosamente.' }
        format.json { render :show, status: :created, location: @cuadro }
      else
        format.html { render :new }
        format.json { render json: @cuadro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cuadros/1
  # PATCH/PUT /cuadros/1.json
  def update
    respond_to do |format|
      if @cuadro.update(cuadro_params)
        format.html { redirect_to @cuadro, notice: 'Cuadro fue editado exitosamente.' }
        format.json { render :show, status: :ok, location: @cuadro }
      else
        format.html { render :edit }
        format.json { render json: @cuadro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuadros/1
  # DELETE /cuadros/1.json
  def destroy
    @cuadro.destroy
    respond_to do |format|
      format.html { redirect_to torneo_categorium_cuadros_url(@torneo,@categorium), notice: 'Cuadro fue destruido exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    def get_categorium
      @categorium= Categorium.find(params[:categorium_id])
    end

    def get_torneo
      @torneo= Torneo.find(params[:torneo_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_cuadro
      @cuadro = Cuadro.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cuadro_params
      params.require(:cuadro).permit(:numero, :etapa, :categorium_id)
    end
end
