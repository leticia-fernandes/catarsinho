class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :find]

  def index
    @projects = current_user.projects
    render "my"
  end

  def new
    @project = Project.new
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      flash[:notice] = "Projeto criado com sucesso."
      redirect_to authenticated_root_path
    else
      render "new"
    end
  end

  def update
    @project = current_user.projects.find(params[:id])

    if @project.update(project_params)
      flash[:notice] = "Projeto atualizado com sucesso."
      redirect_to @project
    else
      render "edit"
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def find
    @projects = Project.order(params[:order])
    page = "index"

    if params[:search].present?
      @projects = @projects.where("projects.title ILIKE ?", "%#{params[:search]}%" )
      page = "result"
    end

    render page
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy

    redirect_back fallback_location: authenticated_root_path
  end

  private

  def project_params
    params.require(:project).permit(:id, :title, :description, :goal, :closing_date)
  end
end
