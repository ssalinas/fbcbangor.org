class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  layout 'admin'

  def info
  end

  def about
    @contents = Array(Content.where(page: 'about').order('priority ASC')) || []
  end

  def homepage
    @image = Content.where(page: 'home', section: 'image').first
    @slogan = Content.where(page: 'home', section: 'slogan').first
    @footer_left = Content.where(page: 'home', section: 'footer_left').first
    @footer_right = Content.where(page: 'home', section: 'footer_right').first
  end

  def find_us
    @address = Content.where(page: 'find_us', section: 'address').first
  end

  def contact
    @phone = Content.where(page: 'contact', section: 'phone').first
    @office = Content.where(page: 'contact', section: 'office').first
    @email = Content.where(page: 'contact', section: 'email').first
  end

  # GET /contents
  def index
    @contents = Content.all
  end

  # GET /contents/1
  def show
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  def create
    @content = Content.new(content_params)

    if @content.save
      redirect_to "/contents/#{@content.page}", notice: 'Content was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /contents/1
  def update
    if @content.update(content_params)
      redirect_to :back, notice: 'Content was successfully updated.'
    else
      render :back
    end
  end

  # DELETE /contents/1
  def destroy
    @content.destroy
    redirect_to :back, notice: 'Content was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def content_params
      params.require(:content).permit(:page, :section, :content, :image_src)
    end
end
