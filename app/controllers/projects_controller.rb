class ProjectsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :find]
  before_action :set_user_project, only: [:edit, :update, :destroy]
  before_action :set_project, only: [:show]

  def index
    @projects = current_user.projects
    render "my"
  end

  def new
    @project = Project.new
  end

  def edit; end

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
    if @project.update(project_params)
      flash[:notice] = "Projeto atualizado com sucesso."
      redirect_to @project
    else
      render "edit"
    end
  end

  def show; end

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
    @project.destroy

    redirect_back fallback_location: authenticated_root_path
  end

  private

  def set_user_project
    @project = current_user.projects.find_by(id: params[:id])
    verify_project_exists
  end

  def set_project
    @project = Project.find_by(id: params[:id])
    verify_project_exists
  end

  def verify_project_exists
    if @project.blank?
      flash[:alert] = "Projeto não encontrado."
      not_found_redirect
    end
  end

  def project_params
    params.require(:project).permit(:id, :title, :description, :goal, :closing_date, :image)
  end
end
