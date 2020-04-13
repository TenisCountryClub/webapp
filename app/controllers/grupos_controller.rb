class GruposController < ApplicationController

  before_action :get_torneo, :get_categorium
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]

  # GET /grupos
  # GET /grupos.json
  def index
    @grupos = @categorium.grupos
  end

  # GET /grupos/1
  # GET /grupos/1.json
  def show
  end

  # GET /grupos/new
  def new
    @grupo = Grupo.new
  end

  # GET /grupos/1/edit
  def edit
  end

  # POST /grupos
  # POST /grupos.json
  def create
    @grupo = @categorium.grupos.build(grupo_params)

    respond_to do |format|
      if @grupo.save
        format.html { redirect_to [@torneo,@categorium,@grupo], notice: 'Grupo was successfully created.' }
        format.json { render :show, status: :created, location: @grupo }
      else
        format.html { render :new }
        format.json { render json: @grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grupos/1
  # PATCH/PUT /grupos/1.json
  def update
    respond_to do |format|
      if @grupo.update(grupo_params)
        format.html { redirect_to [@torneo,@categorium,@grupo], notice: 'Grupo was successfully updated.' }
        format.json { render :show, status: :ok, location: @grupo }
      else
        format.html { render :edit }
        format.json { render json: @grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grupos/1
  # DELETE /grupos/1.json
  def destroy
    @grupo.destroy
    respond_to do |format|
      format.html { redirect_to torneo_categorium_grupos_url(@torneo,@categorium), notice: 'Grupo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def get_torneo
      @torneo=Torneo.find(params[:torneo_id])
    end

    def get_categorium
      @categorium=@torneo.categoria.find(params[:categorium_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_grupo
      @grupo = Grupo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grupo_params
      params.require(:grupo).permit(:numero, :nombre, :categoria_id)
    end
end
