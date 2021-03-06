require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:devboard_task_1)
    CASClient::Frameworks::Rails::Filter.fake('casuser')
    session[:auth_via] = :cas
    session[:user_id] = 1
    session[:cas_user] = 'casuser'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new, params: {project_id: 1}
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, params: {task: { completed_at: @task.completed_at, title: @task.title, project_id: @task.project_id, sort_position: 2 } }
    end

    # assert_redirected_to project_path(assigns(:task).project)
  end

  test "should show task" do
    get :show, params: { id: @task }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @task }
    assert_response :success
  end

  test "should update task" do
    patch :update, params: { id: @task, task: { completed_at: @task.completed_at, title: @task.title, project_id: @task.project_id } }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, params: {id: @task}
    end

    assert_redirected_to tasks_path
  end
end
