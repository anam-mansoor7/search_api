require 'rails_helper'

describe Page, type: :model do
  it { is_expected.to have_many :terms }
end