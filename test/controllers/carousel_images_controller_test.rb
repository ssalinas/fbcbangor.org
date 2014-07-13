require 'test_helper'

class CarouselImagesControllerTest < ActionController::TestCase
  setup do
    @carousel_image = carousel_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carousel_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carousel_image" do
    assert_difference('CarouselImage.count') do
      post :create, carousel_image: { caption: @carousel_image.caption, url: @carousel_image.url }
    end

    assert_redirected_to carousel_image_path(assigns(:carousel_image))
  end

  test "should show carousel_image" do
    get :show, id: @carousel_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @carousel_image
    assert_response :success
  end

  test "should update carousel_image" do
    patch :update, id: @carousel_image, carousel_image: { caption: @carousel_image.caption, url: @carousel_image.url }
    assert_redirected_to carousel_image_path(assigns(:carousel_image))
  end

  test "should destroy carousel_image" do
    assert_difference('CarouselImage.count', -1) do
      delete :destroy, id: @carousel_image
    end

    assert_redirected_to carousel_images_path
  end
end
