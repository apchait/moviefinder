require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  setup do
    @location = locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post :create, location: { formatted_address: @location.formatted_address, lat: @location.lat, lng: @location.lng, movie_id: @location.movie_id, ne_lat: @location.ne_lat, ne_lng: @location.ne_lng, sw_lat: @location.sw_lat, sw_lng: @location.sw_lng }
    end

    assert_redirected_to location_path(assigns(:location))
  end

  test "should show location" do
    get :show, id: @location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location
    assert_response :success
  end

  test "should update location" do
    patch :update, id: @location, location: { formatted_address: @location.formatted_address, lat: @location.lat, lng: @location.lng, movie_id: @location.movie_id, ne_lat: @location.ne_lat, ne_lng: @location.ne_lng, sw_lat: @location.sw_lat, sw_lng: @location.sw_lng }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, id: @location
    end

    assert_redirected_to locations_path
  end
end
