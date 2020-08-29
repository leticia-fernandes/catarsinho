class DonationsController < ApplicationController
  before_action :set_project
  before_action :verify_project_open

	def new
		@donation = Donation.new
	end

  def create
    @donation = @project.donations.new(donation_params)

    if @donation.save
      flash[:notice] = "Projeto apoiado com sucesso."
      redirect_to @project
    else
      render "new"
    end
  end

  private

  def set_project
    @project = Project.find_by(id: params[:project_id])

    if @project.blank?
      flash[:alert] = "Projeto não encontrado."
      not_found_redirect
    end
  end

  def verify_project_open
    unless @project.is_open?
      flash[:alert] = "A campanha para este projeto está encerrada."
      redirect_to @project
    end
  end

  def donation_params
    params.require(:donation).permit(:value).merge({ user_id: current_user.id })
  end
end
