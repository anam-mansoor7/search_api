require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:page) { create(:page) }
  let(:page2) { create(:page) }
  let(:query) { 'chocolates ice' }

  before do
    create(:term, name: 'chocolate', count: 1, page: page2)
    create(:term, name: 'ice', count: 1, page: page2)
    create(:term, name: 'chocolate', count: 4, page: page)
  end

  describe "GET #pages_by_term_count" do
    it "returns a success response" do
      get :pages_by_term_count, params: { query: query }
      puts JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body)[0]['title']).to eq(page.title)
      expect(JSON.parse(response.body)[1]['title']).to eq(page2.title)
    end

    context "when query does not exist" do
      it "returns an error response" do
        get :pages_by_term_count
        expect(response.status).to eq(400)
      end
    end
  end

  describe "GET #pages" do
    it "returns a success response" do
      get :pages, params: { query: query }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body)[0]['title']).to eq(page2.title)
      expect(JSON.parse(response.body)[1]['title']).to eq(page.title)
    end

    context "when query does not exist" do
      it "returns an error response" do
        get :pages
        expect(response.status).to eq(400)
      end
    end
  end
end