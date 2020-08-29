require 'rails_helper'

RSpec.describe ProjectsHelper, type: :helper do

  let(:user_owner) { create(:user) }
  let(:project) { create(:project, user: user_owner) }

  describe "#display_project_actions?" do
    context "Quando o usuário está logado" do
      context "Quando o usuário é o dono do projeto" do
        before { login_user(user_owner) }
        it "retorna verdadeiro" do
          expect(helper.display_project_actions?(project: project)).to be true
        end
      end

      context "Quando o usuário não é o dono do projeto" do
        before { login_user }
        it "retorna falso" do
          expect(helper.display_project_actions?(project: project)).to be false
        end
      end
    end

    context "Quando o usuário não está logado" do
      it "retorna nil" do
        expect(helper.display_project_actions?(project: project)).to be_nil
      end
    end
  end

  describe "#display_edit_project_action" do
    it "retorna link para edição do projeto informado" do
      expect(helper.display_edit_project_action(id: project.id)).to eq(
        link_to helper.fa_icon("pencil"),
                edit_project_path(project.id),
                title: "Editar",
                data: {toggle: "tooltip"}
        )
    end
  end

  describe "#display_delete_project_action" do
    it "retorna link para edição do projeto informado" do
      expect(helper.display_delete_project_action(id: project.id)).to eq(
        link_to helper.fa_icon("trash"),
                project_path(project.id),
                method: :delete,
                data: {confirm: "Você tem certeza disso?", toggle: "tooltip"},
                title: "Excluir"
        )
    end
  end

  describe "#display_days_remaining" do
    context "Quando falta um número inferior a 0 de dias para o encerramento da campanha" do
      it "retorna mensagem" do
        msg = "<span class='text-muted'>Esta campanha está encerrada.</span>"
        expect(helper.display_days_remaining(closing_date: Date.yesterday)).to eq(msg)
      end
    end
    context "Quando faltam 0 dias para o encerramento da campanha" do
      it "retorna mensagem" do
        msg = "Esta campanha encerra <span class='days'>hoje</span>"
        expect(helper.display_days_remaining(closing_date: Date.today)).to eq(msg)
      end
    end
    context "Quando falta 1 dia para o encerramento da campanha" do
      it "retorna mensagem" do
        msg = "Falta <span class='days'>1</span> dia para o encerramento desta campanha."
        expect(helper.display_days_remaining(closing_date: Date.tomorrow)).to eq(msg)
      end
    end
    context "Quando faltam 2 ou mais dias para o encerramento da campanha" do
      it "retorna mensagem" do
        closing_date = Date.today+2.days
        days = ( closing_date - Date.today).to_i
        msg = "Faltam <span class='days'>#{days}</span> dias para o encerramento desta campanha."
        expect(helper.display_days_remaining(closing_date: closing_date)).to eq(msg)
      end
    end
  end

  describe "#calc_days_remaining" do
    it "retorna a quantidade de dias restantes para o fim da campanha" do
      expect(helper.calc_days_remaining(Date.today)).to eq(0)
    end
  end

  describe "#convert_money" do
    it "retorna um número formatado para BRL" do
      expect(helper.convert_money(1)).to eq("R$ 1,00")
    end
  end

  describe "#display_donation_button" do
    let(:user_owner) { create(:user) }
    let(:project) { create(:project, user: user_owner) }

    context "Quando a campanha está encerrada" do
      before { allow(project).to receive(:closing_date).and_return(Date.yesterday) }
      it "retorna botão desabilitado" do
        expect(helper.display_donation_button(project: project)).
        to eq(content_tag(:button, "Encerrado", class: "btn btn-lg btn-secondary w-100", disabled: true ))
      end
    end

    context "Quando a campanha está não encerrada" do
      context "Quando o usuário não estiver logado" do
        it "retorna botão habilitado" do
          expect(helper.display_donation_button(project: project)).
          to eq(content_tag(:button, "Apoie!", class: "btn btn-lg btn-catarsinho-yellow w-100", disabled: false ))
        end
      end

      context "Quando o usuário estiver logado" do
        context "Quando o usuário não for dono do projeto" do
          before { login_user }
          it "retorna botão habilitado" do
            expect(helper.display_donation_button(project: project)).
            to eq(content_tag(:button, "Apoie!", class: "btn btn-lg btn-catarsinho-yellow w-100", disabled: false ))
          end
        end

        context "Quando o usuário for dono do projeto" do
          before { login_user(user_owner) }
          it "retorna botão desabilitado" do
            expect(helper.display_donation_button(project: project)).
            to eq(content_tag(:button, "Apoie!", class: "btn btn-lg btn-catarsinho-yellow w-100", disabled: true ))
          end
        end
      end
    end
  end

  describe "#display_order" do
    it "renderiza partial 'order'" do
      allow(helper).to receive(:render)
      helper.display_order

      expect(helper).to have_received(:render).with(partial: "order")
    end
  end
end
