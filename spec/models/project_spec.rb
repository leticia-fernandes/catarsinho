require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "Attributos" do
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:goal) }
    it { is_expected.to respond_to(:closing_date) }
    it { is_expected.to respond_to(:user) }
  end

  describe "Relações" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:donations).dependent(:delete_all) }
    it { is_expected.to have_many(:donators).through(:donations) }
  end

  describe "Validações" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:goal) }
    it { is_expected.to validate_presence_of(:closing_date) }
    it { is_expected.to validate_presence_of(:user) }

    it { is_expected.to validate_length_of(:title).is_at_most(64) }
    it { is_expected.to validate_length_of(:description).is_at_most(512) }
    it { is_expected.to validate_numericality_of(:goal).
                        is_greater_than(0).
                        is_less_than_or_equal_to(Project::MAX_GOAL) }
    it { is_expected.to validate_inclusion_of(:closing_date).in_range((Date.tomorrow)...(Date.today+30.days)) }

    describe 'Imagem' do
      context "Quando o arquivo é enviado" do
        context "Quando o arquivo é do tipo imagem" do
          it 'anexa o arquivo' do
            subject.image.attach(fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-image.png'), 'image/png'))
            expect(subject.image).to be_attached
          end
        end

        context "Quando o arquivo  não é do tipo imagem" do
          it 'retorna mensagem de erro' do
            subject.image.attach(fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'test-pdf.pdf'), 'application/pdf'))
            subject.save
            expect(subject.errors.messages[:base]).to include("O arquivo deve ser uma imagem.")
          end
        end
      end

      context "Quando o arquivo não é enviado" do
        it "retorna mensagem de erro" do
          subject.image.attach(nil)
          subject.save
          expect(subject.errors.messages[:base]).to include("Uma imagem deve ser enviada.")
        end
      end
    end
  end

  describe "Factory" do
    it { expect(build(:project)).to be_a Project }
    it { expect(build(:project)).to be_valid }
  end

  describe "Métodos" do
    let(:project) { create(:project) }

    describe ".is_open?" do
      context "Quando o projeto está entre a data atual e menor que a data atual + 30 dias" do
        it "retorna verdadeiro" do
          expect(project.is_open?).to be true
        end
      end

      context "Quando o projeto não está entre a data atual e menor que a data atual + 30 dias" do
        before { allow(project).to receive(:closing_date).and_return(Date.yesterday) }

        it "retorna falso" do
          expect(project.is_open?).to be false
        end
      end
    end

    describe "#total_donations" do
      it "retorna a soma das doações do projeto" do
        expect(project.total_donations).to eq(project.donations.sum(:value))
      end
    end
  end
end
