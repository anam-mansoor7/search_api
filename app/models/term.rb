class Term < ApplicationRecord
  belongs_to :page

  WORD_REGEX = /\b[a-z]{3,16}\b/.freeze
end
