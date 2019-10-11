require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #pages" do
    let(:page) { create(:page) }
    let(:page2) { create(:page) }

    before { create(:term, name: 'chocolates', count: 1, page: page) }
    it "returns a success response" do
      get :pages, params: { query: 'chocolates' }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(1)
      expect(JSON.parse(response.body)[0]['title']).to eq(page.title)
    end

    context "when query does not exist" do
      it "returns an error response" do
        get :pages
        expect(response.status).to eq(400)
      end
    end
  end
end