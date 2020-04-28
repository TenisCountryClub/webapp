class CategoriaController < ApplicationController
  before_action :get_torneo
  before_action :set_categorium, only: [:show, :edit, :update, :destroy, :sortear]
  

  # GET /categoria
  # GET /categoria.json
  def index
    @categoria = @torneo.categoria
  end

  def sortear
    @categorium.sortear_categoria
    if @categorium.tipo=="cuadroAvance"
      
      redirect_to torneo_categorium_cuadro_jugadors_path(@torneo,@categorium)
    elsif @categorium.tipo=="roundRobin"
      
      redirect_to torneo_categorium_grupo_jugadors_path(@torneo,@categorium)
    end
  end

  # GET /categoria/1
  # GET /categoria/1.json
  def show
  end

  # GET /categoria/new
  def new
    @categorium = @torneo.categoria.build
  end

  # GET /categoria/1/edit
  def edit
  end

  # POST /categoria
  # POST /categoria.json
  def create
    @categorium = @torneo.categoria.build(categorium_params)

    respond_to do |format|
      if @categorium.save
        format.html { redirect_to torneo_categoria_path(@torneo), notice: 'Categoría fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @categorium }
      else
        format.html { render :new }
        format.json { render json: @categorium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categoria/1
  # PATCH/PUT /categoria/1.json
  def update
    respond_to do |format|
      if @categorium.update(categorium_params)
        format.html { redirect_to torneo_categoria_path(@torneo), notice: 'Categoría fue editada exitosamente.' }
        format.json { render :show, status: :ok, location: @categorium }
      else
        format.html { render :edit }
        format.json { render json: @categorium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categoria/1
  # DELETE /categoria/1.json
  def destroy
    @categorium.destroy
    respond_to do |format|
      format.html { redirect_to torneo_categoria_path(@torneo), notice: 'Categoría fue destruida exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    def get_torneo
      @torneo=Torneo.find(params[:torneo_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_categorium
      @categorium = @torneo.categoria.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def categorium_params
      params.require(:categorium).permit(:nombre, :numero_jugadores, :numero_grupos, :numero_jugadores_grupo, :tipo, :torneo_id)
    end
end
