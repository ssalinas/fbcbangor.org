class CarouselImagesController < ApplicationController
  before_action :set_carousel_image, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  layout 'admin'

  # GET /carousel_images
  def index
    @carousel_images = CarouselImage.all
  end

  # GET /carousel_images/1
  def show
  end

  # GET /carousel_images/new
  def new
    @carousel_image = CarouselImage.new
  end

  # GET /carousel_images/1/edit
  def edit
  end

  # POST /carousel_images
  def create
    @carousel_image = CarouselImage.new(carousel_image_params)

    if @carousel_image.save
      redirect_to @carousel_image, notice: 'Carousel image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /carousel_images/1
  def update
    if @carousel_image.update(carousel_image_params)
      redirect_to @carousel_image, notice: 'Carousel image was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /carousel_images/1
  def destroy
    @carousel_image.destroy
    redirect_to carousel_images_url, notice: 'Carousel image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carousel_image
      @carousel_image = CarouselImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def carousel_image_params
      params.require(:carousel_image).permit(:url, :caption)
    end
end
