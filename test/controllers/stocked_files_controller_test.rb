require 'test_helper'

class StockedFilesControllerTest < ActionController::TestCase
  setup do
    @stocked_file = stocked_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stocked_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stocked_file" do
    assert_difference('StockedFile.count') do
      post :create, stocked_file: { hash: @stocked_file.hash, original_name: @stocked_file.original_name }
    end

    assert_redirected_to stocked_file_path(assigns(:stocked_file))
  end

  test "should show stocked_file" do
    get :show, id: @stocked_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stocked_file
    assert_response :success
  end

  test "should update stocked_file" do
    patch :update, id: @stocked_file, stocked_file: { hash: @stocked_file.hash, original_name: @stocked_file.original_name }
    assert_redirected_to stocked_file_path(assigns(:stocked_file))
  end

  test "should destroy stocked_file" do
    assert_difference('StockedFile.count', -1) do
      delete :destroy, id: @stocked_file
    end

    assert_redirected_to stocked_files_path
  end
end
