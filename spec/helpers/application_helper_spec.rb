require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "#display_find_form" do
    it "renderiza projects/find_form" do
      allow(helper).to receive(:render)
      helper.display_find_form

      expect(helper).to have_received(:render).with(partial: "projects/find_form")
    end
  end
end
