require 'rails_helper'

RSpec.describe DonationsController, type: :controller do
  let(:project) { create(:project) }

  before { login_user }

  describe "GET #new" do
    context "Quando o projeto selecionado para apoiar existe" do
      context "Quando a campanha está aberta" do
        before { allow(project).to receive(:is_open?).and_return(true) }

        it "retorna uma nova instância de Donation" do
          get :new, params: { project_id: project.id }
          expect(assigns(:project)).to be_a Project
        end
      end

      context "Quando a campanha está encerrada" do
        before { allow_any_instance_of(Project).to receive(:is_open?).and_return(false) }

        it "redireciona para a página do projeto" do
          get :new, params: { project_id: project.id }
          expect(response).to redirect_to project
        end

        it "retorna mensagem de erro" do
          get :new, params: { project_id: project.id }
          expect(flash[:alert]).to eq "A campanha para este projeto está encerrada"
        end
      end
    end

    context "Quando o projeto selecionado para apoiar não existe" do
      it "redireciona para a página de 'find'" do
        get :new, params: { project_id: Faker::Number.number(digits: 3) }
        expect(response).to redirect_to find_projects_path
      end
    end
  end

  describe "POST #create" do
    subject { build(:donation) }
    let(:valid_params) {
                        { project_id: project.id,
                          donation: {
                          value: subject.value }
                        }
                      }

    context "Quando o projeto selecionado existe" do
      context "Quando a campanha ainda está ativa" do
        context "Quando passado atributos válidos" do
          it "cria uma nova doação" do
            expect {
              post :create, params: valid_params
            }.to change(Donation, :count).by(1)
          end

          it "redireciona para página do projeto" do
            post :create, params: valid_params
            expect(response).to redirect_to project
          end
        end

        context "Quando passado atributos inválidos" do
          let(:invalid_params) { valid_params }

          before { invalid_params[:donation][:value] = 0 }

          it "não cria um novo projeto" do
            expect {
              post :create, params: invalid_params
            }.to change(Donation, :count).by(0)
          end

          it "renderiza template 'new'" do
            post :create, params: invalid_params
            expect(response).to render_template 'new'
          end
        end
      end

      context "Quando a campanha está encerrada" do
        before { allow_any_instance_of(Project).to receive(:is_open?).and_return(false) }

        it "redireciona para a página do projeto" do
          get :create, params: { project_id: project.id }
          expect(response).to redirect_to project
        end

        it "retorna mensagem de erro" do
          get :create, params: { project_id: project.id }
          expect(flash[:alert]).to eq "A campanha para este projeto está encerrada"
        end
      end
    end

    context "Quando o projeto selecionado não existe" do
      it "redireciona para a página de 'find'" do
        get :create, params: { project_id: Faker::Number.number(digits: 3) }
        expect(response).to redirect_to find_projects_path
      end
    end
  end
end
