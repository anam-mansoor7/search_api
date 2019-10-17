class Command::SearchPagesByTermCount
  include Dry::Transaction

  MAX_QUERY_SIZE = 2000.freeze

  step :validate_query
  step :parse_query
  step :lemmatize_query
  step :search_document_terms
  step :sort_pages_by_frequency_count

  def validate_query(input)
    return Failure('query field is required') unless input[:query].present?
    return Failure("Length of query should be less than #{MAX_QUERY_SIZE}") if input[:query].length > MAX_QUERY_SIZE

    Success(input)
  end

  def parse_query(input)
    input[:parsed_query] = input[:query].downcase.scan(Term::WORD_REGEX)
    Success(input)
  end

  def lemmatize_query(input)
    lemmatizer = Lemmatizer.new
    input[:parsed_query].map! { |token| lemmatizer.lemma(token) }

    Success(input)
  end

  def search_document_terms(input)
    input[:terms] = Term.where(name: input[:parsed_query])
    Success(input)
  end

  def sort_pages_by_frequency_count(input)
    pages = Page.joins(:terms).where(terms: {id: input[:terms].pluck(:id)})
    input[:pages] = pages.select('pages.id, pages.title, pages.link, sum(terms.count) as relevance')
      .group('pages.id').order('relevance DESC')
    Success(input)
  end
end