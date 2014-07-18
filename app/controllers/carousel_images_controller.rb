class CarouselImagesController < ApplicationController
  before_action :set_carousel_image, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  layout 'admin'

  def index
    @carousel_images = CarouselImage.all
  end

  def show
  end

  def new
    @carousel_image = CarouselImage.new
  end

  def edit
  end

  def create
    @carousel_image = CarouselImage.new(carousel_image_params)
    if @carousel_image.save
      redirect_to @carousel_image, notice: 'Carousel image was successfully created.'
    else
      render :new
    end
  end

  def update
    if @carousel_image.update(carousel_image_params)
      redirect_to @carousel_image, notice: 'Carousel image was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @carousel_image.destroy
    redirect_to carousel_images_url, notice: 'Carousel image was successfully destroyed.'
  end

private
  def set_carousel_image
    @carousel_image = CarouselImage.find(params[:id])
  end

  def carousel_image_params
    params.require(:carousel_image).permit(:url, :caption)
  end
end
