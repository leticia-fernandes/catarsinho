require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  let(:user) { create(:user) }
  let!(:project_user) { create(:project, user: user) }
  let!(:project_user_to_delete) { create(:project, user: user) }
  let!(:project) { create(:project) }

  describe "Rotas com usuário logado" do
    before { login_user(user) }

    describe "GET #index" do
      it "retorna os projetos do usuário logado" do
        get :index
        expect(assigns(:projects)).to eq(user.projects)
      end

      it "renderiza template 'my'" do
        get :index
        expect(response).to render_template "my"
      end
    end

    describe "GET #new" do
      it "retorna uma nova instância de Project" do
        get :new
        expect(assigns(:project)).to be_a Project
      end
    end

    describe "GET #edit" do
      it "retorna o projeto solicitado do usuário logado" do
        get :edit, params: { id: project_user.id }
        expect(assigns(:project)).to eq(project_user)
      end
    end

    describe "POST #create" do
      subject { build(:project) }
      let(:valid_params) {
                          { project: {
                            title: subject.title,
                            description: subject.description,
                            goal: subject.goal,
                            closing_date: subject.closing_date,
                            image: fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-image.png'), 'image/png')
                            }
                          }
                        }

      context "Quando passado atributos válidos" do
        it "cria um novo projeto" do
          expect {
            post :create, params: valid_params
          }.to change(Project, :count).by(1)
        end

        it "anexa a imagem" do
          expect {
            post :create, params: valid_params
          }.to change(ActiveStorage::Attachment, :count).by(1)
        end

        it "redireciona para authenticated_root_path" do
          post :create, params: valid_params
          expect(response).to redirect_to authenticated_root_path
        end
      end

      context "Quando passado atributos inválidos" do
        let(:invalid_params) { valid_params }

        before { invalid_params[:project][:goal] = Project::MAX_GOAL+1 }

        it "nao cria um novo projeto" do
          expect {
            post :create, params: invalid_params
          }.to change(Project, :count).by(0)
        end
      end
    end

    describe "PUT #update" do
      subject { build(:project) }
      let(:valid_params) { { id: project_user.id, project: { goal: subject.goal } } }
      let(:invalid_goal) { Project::MAX_GOAL+1 }
      let(:invalid_params) { { id: project_user.id, project: { goal: invalid_goal } } }

      context "Quando passado atributos válidos" do
        it "atualiza o projeto" do
          put :update, params: valid_params
          project_user.reload
          expect(project_user.goal).to eq subject.goal
        end

        it "redireciona para a página do projeto" do
          put :update, params: valid_params
          expect(response).to redirect_to project_user
        end
      end

      context "Quando passado atributos inválidos" do
        it "nao atualiza o projeto" do
          put :update, params: invalid_params
          project_user.reload
          expect(project_user.goal).not_to eq invalid_goal
        end
      end
    end

    describe "DELETE #destroy" do
      it "deleta o projeto" do
        delete :destroy, params: { id: project_user_to_delete.id }
        expect(user.projects.include?(project_user_to_delete)).to be false
      end

      it "redireciona para a página anterior ou para o fallback_location" do
        delete :destroy, params: { id: project_user_to_delete.id }
        expect(response).to redirect_to authenticated_root_path
      end
    end
  end

  describe "Rotas sem usuário logado" do
    describe "GET #show" do
      it "retorna o projeto selecionado" do
        get :show, params: { id: project }
        expect(assigns(:project)).to eq(project)
      end
    end

    describe "GET #find" do
      context "Quando params[:search] está presente" do
        let(:title) { "Projeto" }
        let!(:project_search_1) { create(:project, title: title+"Z") }
        let!(:project_search_2) { create(:project, title: title+"A") }
        let!(:projects) { [project_search_1, project_search_2] }

        context "Quando o params[:order] está presente" do
          it "retorna os projetos que possuem em seu titulo o params[:search] ordenados por params[:order]" do
            get :find, params: { search: title, order: "title" }

            expect(assigns(:projects).to_a).to eq(projects.sort_by(&:title))
          end
        end

        context "Quando o params[:order] não está presente" do
          it "retorna os projetos que possuem em seu titulo o params[:search] ordenados pelo updated_at" do
            get :find, params: { search: title }
            expect(assigns(:projects).to_a).to eq(projects.sort_by(&:updated_at))
          end
        end

        it "renderiza o template 'result'" do
          get :find, params: { search: project.title, order: "title" }
          expect(response).to render_template "result"
        end

      end
      context "Quando params[:search] não está presente" do
        context "Quando o params[:order] está presente" do
          it "retorna todos os projetos ordenados por params[:order]" do
            get :find, params: { order: "title" }
            expect(assigns(:projects).to_a).to eq(Project.all.sort_by(&:title))
          end
        end

        context "Quando o params[:order] não está presente" do
          it "retorna todos os projetos ordenado pelo updated_at" do
            get :find, params: {}
            expect(assigns(:projects).to_a).to eq(Project.all.sort_by(&:updated_at))
          end
        end

        it "renderiza o template 'index'" do
          get :find, params: {}
          expect(response).to render_template "index"
        end
      end
    end
  end
end
