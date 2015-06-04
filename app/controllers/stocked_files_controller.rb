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
    data = stocked_file_create_params[:data]
    hash = Digest::MD5.hexdigest(stocked_file_create_params[:filename] + Time.now.to_s)
    while StockedFile.where(hash: hash).count > 0
      hash = Digest::MD5.hexdigest(Random.rand.to_s)
    end
    File.open(get_file_path(hash), "wb") { |f|
      f.write(data)
    }
    @stocked_file = StockedFile.new({
      original_name: stocked_file_create_params[:filename],
      hash: hash,
      size: data.bytesize
    })

    respond_to do |format|
      if @stocked_file.save
        format.html { redirect_to @stocked_file, notice: 'Stocked file was successfully created.' }
        format.json { render :show, status: :created, location: @stocked_file }
        format.txt  { render get_url(hash) }
      else
        format.html { render :new }
        format.json { render json: @stocked_file.errors, status: :unprocessable_entity }
        format.txt  { render "error" }
      end
    end
  end

  def get_file_path(hash)
    dir = "public/files/#{hash[0]}/#{hash[1..hash.length]}"
    if !Dir.exists?(dir)
      Dir.mkdir(dir)
    end
    dir
  end

  def get_url(hash)
    "http://filezo.hidesys.net/#{hash}"
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
      @stocked_file = StockedFile.find_by(id: params[:id]) || StockedFile.find_by(hash: params[:hash])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stocked_file_params
      params.require(:stocked_file).permit(:original_name, :hash)
    end

   def stocked_file_create_params
      params.permit(:filename, :data)
   end
end
