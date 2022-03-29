class ImagesController < ApplicationController
  def new
  	@image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if @image.save
      flash[:notice] = "Image Created"

      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
  end

  def index
  end

  private
    def image_params
      params.require(:image).permit(:image, :category_id, :image_title, :image_description, :image_file_size, :image_content_type, :remote_image_url)
    end
end
