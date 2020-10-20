require 'rails_helper'

RSpec.describe SearchPagesByTsVectorController, type: :controller do
  let(:page1_text) do
    "ice ice cream cream cream cream chocolates chocolate chocolate"
  end
  let(:page2_text) do
    "food food web web web web web chocolate chocolate chocolate chocolate chocolate chocolate chocolate chocolate"
  end
  let!(:page1) { create(:page, doc_text: page1_text) }
  let!(:page2) { create(:page, doc_text: page2_text) }
  let(:query) { 'chocolates ice' }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { query: query }
      puts JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body)[0]['title']).to eq(page1.title)
      expect(JSON.parse(response.body)[1]['title']).to eq(page2.title)
    end

    context "when query does not exist" do
      it "returns an error response" do
        get :index
        expect(response.status).to eq(400)
      end
    end
  end
end