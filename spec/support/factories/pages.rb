FactoryBot.define do
  factory :page, class: Page do
    title {|n| "page#{n}" }
  end
end