FactoryBot.define do
  factory :term, class: Term do
    name {|n| "term#{n}" }
    count {|n| n }
  end
end