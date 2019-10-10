class Command::SearchPages
  include Dry::Transaction

  step :validate_query
  step :parse_query
  step :search_document_terms
  step :sort_pages_by_frequency_count

  def validate_query(input)
    return Failure('query field is required') unless input[:query]

    Success(input)
  end

  def parse_query(input)
    input[:parsed_query] = input[:query].scan(/\b[a-z]{3,16}\b/)
    Success(input)
  end

  def search_document_terms(input)
    input[:terms] = Term.where(name: input[:parsed_query])
    Success(input)
  end

  def sort_pages_by_frequency_count(input)
    pages = Page.joins(:terms).where(terms: {id: input[:terms].pluck(:id)})
    input[:pages] = pages.select('pages.id, pages.title, pages.link, sum(terms.count) as term_count')
      .group('pages.id').order('term_count DESC')
    Success(input)
  end
end