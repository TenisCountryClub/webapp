class LlavesController < ApplicationController
  before_action :set_llafe, only: [:show, :edit, :update, :destroy]

  # GET /llaves
  # GET /llaves.json
  def index
    @llaves = Llave.all
  end

  # GET /llaves/1
  # GET /llaves/1.json
  def show
  end

  # GET /llaves/new
  def new
    @llafe = Llave.new
  end

  # GET /llaves/1/edit
  def edit
  end

  # POST /llaves
  # POST /llaves.json
  def create
    @llafe = Llave.new(llafe_params)

    respond_to do |format|
      if @llafe.save
        format.html { redirect_to @llafe, notice: 'Llave was successfully created.' }
        format.json { render :show, status: :created, location: @llafe }
      else
        format.html { render :new }
        format.json { render json: @llafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /llaves/1
  # PATCH/PUT /llaves/1.json
  def update
    respond_to do |format|
      if @llafe.update(llafe_params)
        format.html { redirect_to @llafe, notice: 'Llave was successfully updated.' }
        format.json { render :show, status: :ok, location: @llafe }
      else
        format.html { render :edit }
        format.json { render json: @llafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /llaves/1
  # DELETE /llaves/1.json
  def destroy
    @llafe.destroy
    respond_to do |format|
      format.html { redirect_to llaves_url, notice: 'Llave was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_llafe
      @llafe = Llave.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def llafe_params
      params.require(:llafe).permit(:torneo_id, :etapa, :numero)
    end
end
