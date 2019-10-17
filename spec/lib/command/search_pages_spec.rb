require "rails_helper"

RSpec.describe Command::SearchPages do
  let(:service) { described_class.new }
  let(:do_call) { service.call(query: query) }
  let(:page1) { create(:page) }
  let(:page2) { create(:page) }
  let(:query) { 'chocolates ice' }

    describe "#call" do
      context "when the results exists" do
        before do
          create(:term, name: 'ice', count: 2, page: page1)
          create(:term, name: 'cream', count: 4, page: page1)
          create(:term, name: 'chocolate', count: 4, page: page1)
          create(:term, name: 'food', count: 2, page: page2)
          create(:term, name: 'web', count: 4, page: page2)
          create(:term, name: 'school', count: 4, page: page2)
          create(:term, name: 'chocolate', count: 8, page: page2)
        end

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