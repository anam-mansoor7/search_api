class Page < ApplicationRecord
  has_many :terms

  attr_accessor :relevance
end
