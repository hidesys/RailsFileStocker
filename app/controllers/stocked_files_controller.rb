class StockedFilesController < ApplicationController
  before_action :set_stocked_file, only: [:show, :edit, :update, :destroy]

  # GET /stocked_files
  # GET /stocked_files.json
  def index
    @stocked_files = StockedFile.all
  end

  # GET /stocked_files/1
  # GET /stocked_files/1.json
  def show
  end

  # GET /stocked_files/new
  def new
    @stocked_file = StockedFile.new
  end

  # GET /stocked_files/1/edit
  def edit
  end

  # POST /stocked_files
  # POST /stocked_files.json
  def create
    @stocked_file = StockedFile.new(stocked_file_params)

    respond_to do |format|
      if @stocked_file.save
        format.html { redirect_to @stocked_file, notice: 'Stocked file was successfully created.' }
        format.json { render :show, status: :created, location: @stocked_file }
      else
        format.html { render :new }
        format.json { render json: @stocked_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocked_files/1
  # PATCH/PUT /stocked_files/1.json
  def update
    respond_to do |format|
      if @stocked_file.update(stocked_file_params)
        format.html { redirect_to @stocked_file, notice: 'Stocked file was successfully updated.' }
        format.json { render :show, status: :ok, location: @stocked_file }
      else
        format.html { render :edit }
        format.json { render json: @stocked_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocked_files/1
  # DELETE /stocked_files/1.json
  def destroy
    @stocked_file.destroy
    respond_to do |format|
      format.html { redirect_to stocked_files_url, notice: 'Stocked file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stocked_file
      @stocked_file = StockedFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stocked_file_params
      params.require(:stocked_file).permit(:original_name, :hash)
    end
end
