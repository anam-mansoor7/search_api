require 'rails_helper'

describe Term, type: :model do
  it { is_expected.to belong_to :page }
end