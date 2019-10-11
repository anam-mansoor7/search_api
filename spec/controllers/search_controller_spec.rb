require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #pages" do
    let(:page) { create(:page) }
    it "returns a success response" do
      get :pages, params: { query: 'coo' }
      expect(response.status).to eq(204)
    end

    context "when query does not exist" do
      it "returns an error response" do
        get :pages
        expect(response.status).to eq(400)
      end
    end
  end
end