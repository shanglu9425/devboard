class TasksController < ApplicationController
  load_and_authorize_resource
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    
    if params[:project_id] and (Project.find_by_id(params[:project_id]) != nil)
      @task.project_id = params[:project_id]
    else
      flash[:alert] = "Invalid Project ID."
      redirect_to projects_url
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    create_github_issue if @task.valid? and params[:create_github_issue] == '1'

    respond_to do |format|
      if @task.save
        notice_txt = 'Task was successfully created.'
        notice_txt += " GitHub issue ##{@task.gh_issue_number}." if @task.gh_issue_number
        
        ActivityLog.create!({developer_id: current_user.developer_id, project_id: @task.project_id, task_id: @task.id, activity_type: :created })
        
        format.html { redirect_to @task.project, notice: notice_txt }
        format.json { render action: 'show', status: :created, location: @task }
      else
        logger.debug @task.errors.full_messages
        
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    completed_val_before = @task.completed
    
    respond_to do |format|
      if @task.update(task_params)
        
        # AR Dirty will clear @task.changes in the above update but we need to do this
        # after the update in order to know that the update was successful.
        if @task.gh_issue_number and (completed_val_before != @task.completed) and not @task.completed.blank?
          Rails.logger.debug "closing a github issue"
          close_github_issue
          ActivityLog.create!({developer_id: current_user.developer_id, project_id: @task.project_id, task_id: @task.id, activity_type: :completed })
        else
          Rails.logger.debug "not closing a github issue"
        end
        
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        logger.debug @task.errors.full_messages
        
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :details, :developer_id, :project_id, :completed, :difficulty, :duration, :due)
    end
    
    # Uses the GitHub API to create a GitHub issue
    def create_github_issue
      github = Github.new oauth_token: current_user.developer.gh_personal_token
      
      ret = github.issues.create @task.project.gh_repo_url_parse(:user), @task.project.gh_repo_url_parse(:project),
      {
        "title" => @task.title,
        "body" => @task.details
        #"assignee" => current_user.developer.gh_username
      }
      
      @task.gh_issue_number = ret[:number]
    end
    
    # Uses the GitHub API to close a GitHub issue
    def close_github_issue
      github = Github.new oauth_token: current_user.developer.gh_personal_token
      
      ret = github.issues.edit @task.project.gh_repo_url_parse(:user), @task.project.gh_repo_url_parse(:project), @task.gh_issue_number,
      {
        "state" => 'closed'
      }
      
      @gh_closed_at = ret[:closed_at]
    end
end
