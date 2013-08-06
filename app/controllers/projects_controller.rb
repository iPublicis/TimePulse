class ProjectsController < ApplicationController
  before_filter :require_admin!

  # GET /projects
  def index
    @root_project = Project.root
  end

  # GET /projects/1
  def show
    @project = Project.find(params[:id])

    @active_users = User.active
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.rates.build
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @project.rates.build if @project.parent == Project.root
  end

  # POST /projects
  def create
    @project = Project.new(params[:project])

    if @project.save
      flash[:notice] = 'Project was successfully created.'
      expire_fragment "picker_node_#{@project.id}"
      expire_fragment "project_picker"
      redirect_to(@project)
    else
      @project.rates.build
      render :action => "new"
    end
  end

  # PUT /projects/1
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      expire_fragment "picker_node_#{@project.id}"
      expire_fragment "project_picker"
      flash[:notice] = 'Project was successfully updated.'
      redirect_to(@project)
    else
      @project.rates.build
      render :action => "edit"
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @id = params[:id]
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js
    end
  end

end
