require "digest/md5"

class StockedFilesController < ApplicationController
  before_action :set_stocked_file, only: [:show, :destroy, :download]
  protect_from_forgery except: :create

  # GET /stocked_files
  # GET /stocked_files.json
  def index
    @title = "ファイル一覧"
    @stocked_files = StockedFile.order("id DESC").all
  end

  # GET /stocked_files/1
  # GET /stocked_files/1.json
  def show
    @title = @stocked_file.original_name
  end

  # GET /stocked_files/new
  def new
    @title = "ファイルアップロード"
    @stocked_file = StockedFile.new
  end

  # POST /stocked_files
  # POST /stocked_files.json
  def create
    file = stocked_file_create_params[:filedata]
    hash_key = Digest::MD5.hexdigest(file.original_filename + Time.now.to_s)
    while StockedFile.where(hash_key: hash_key).count > 0
      hash_key = Digest::MD5.hexdigest(Random.rand.to_s)
    end
    File.open(get_file_path(hash_key), "wb") { |f|
      f.write(file.read)
    }
    @stocked_file = StockedFile.new({
      original_name: file.original_filename,
      hash_key: hash_key,
      size: file.size
    })

    respond_to do |format|
      if @stocked_file.save
        format.html { redirect_to @stocked_file, notice: 'Stocked file was successfully created.' }
        format.json { render :show, status: :created, location: @stocked_file }
        format.txt  { render plain: get_url(hash_key) }
      else
        format.html { render :new }
        format.json { render json: @stocked_file.errors, status: :unprocessable_entity }
        format.txt  { render plain: "error" }
      end
    end
  end

  def get_file_path(obj)
    hash_key = obj.is_a?(StockedFile) ? obj.hash_key : obj
    dir = "public/files/#{hash_key[0]}/"
    if !Dir.exists?(dir)
      Dir.mkdir(dir)
    end
    dir + hash_key[1..hash_key.length]
  end

  def get_url(hash)
    "http://filezo.hidesys.net/#{hash}"
  end

  def download
    file_path = get_file_path(@stocked_file.hash_key)
    send_file(file_path, filename: @stocked_file.original_name)
  end

  # DELETE /stocked_files/1
  # DELETE /stocked_files/1.json
  def destroy
    File.delete(get_file_path(@stocked_file))
    @stocked_file.destroy
    respond_to do |format|
      format.html { redirect_to stocked_files_url, notice: 'Stocked file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stocked_file
      @stocked_file = StockedFile.find_by(id: params[:id]) || StockedFile.find_by(hash_key: params[:hash_key])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stocked_file_params
      params.require(:stocked_file).permit(:original_name, :hash_key)
    end

   def stocked_file_create_params
      params.permit(:filedata)
   end
end
