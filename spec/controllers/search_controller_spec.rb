require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #pages" do
    let(:page) { create(:page) }
    it "returns a success response" do
      get :pages, params: { query: 'coo' }
      expect(response.status).to eq(200)
    end
  end
end