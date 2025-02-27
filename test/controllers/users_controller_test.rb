require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: @user.email, hashed_password: @user.hashed_password, name: @user.name, portait_path: @user.portait_path, salt: @user.salt, student_number: @user.student_number, team_id: @user.team_id, true_name: @user.true_name, type: @user.type }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { email: @user.email, hashed_password: @user.hashed_password, name: @user.name, portait_path: @user.portait_path, salt: @user.salt, student_number: @user.student_number, team_id: @user.team_id, true_name: @user.true_name, type: @user.type }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
