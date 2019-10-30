require "rails_helper"

RSpec.describe Command::SearchPagesByTsVector do
  let(:service) { described_class.new }
  let(:do_call) { service.call(query: query) }
  let(:page1_text) do
    "ice ice cream cream cream cream chocolates chocolate chocolate"
  end
  let(:page2_text) do
    "food food web web web web web chocolate chocolate chocolate chocolate chocolate chocolate chocolate chocolate"
  end
  let!(:page1) { create(:page, doc_text: page1_text) }
  let!(:page2) { create(:page, doc_text: page2_text) }
  let(:query) { 'chocolates ice' }

  describe "#call" do
    context "when the results exists" do
      it "returns the pages ordered by relevance" do
        pages = do_call.success[:pages]
        expect(pages).to eq([page1, page2])
      end

      it "calculates the relevance correctly" do
        pages = do_call.success[:pages]
        aggregate_failures do
          expect(pages[0].relevance).to eq(0.9855637508055958)
          expect(pages[1].relevance).to eq(0.5801764227838352)
        end
      end
    end

    context "When no matching documents exist" do
      it "returns an empty result" do
        pages = do_call.success[:pages]
        expect(pages).to eq([])
      end
    end
  end
end