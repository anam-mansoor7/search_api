class Command::SearchPages
  include Dry::Transaction

  MAX_QUERY_SIZE = 2000.freeze

  step :validate_query
  step :parse_query
  step :lemmatize_query
  step :search_document_terms
  step :create_term_count_hash
  step :create_corpus
  step :add_query_to_corpus
  step :create_similarity_matrix_model
  step :calculate_page_relevance

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

  def create_term_count_hash(input)
    input[:term_count_hash] = create_term_counts(input[:terms].order(:page_id))

    Success(input)
  end

  def create_corpus(input)
    input[:corpus] = []

    input[:term_count_hash].each do |page_id, term_count_hash|
      input[:corpus] << TfIdfSimilarity::Document.new('', { term_counts: term_count_hash, id: page_id } )
    end

    Success(input)
  end

  def add_query_to_corpus(input)
    input[:corpus] << TfIdfSimilarity::Document.new(input[:parsed_query].join(' '))
    Success(input)
  end

  def create_similarity_matrix_model(input)
    input[:model] = TfIdfSimilarity::TfIdfModel.new(input[:corpus], library: :nmatrix)
    Success(input)
  end

  def calculate_page_relevance(input)
    query_document = input[:corpus].last
    similarity_matrix = input[:model].similarity_matrix
    input[:pages] = []

    input[:corpus][0...-1].each do |document|
      relevance = similarity_matrix[input[:model].document_index(document), input[:model].document_index(query_document)]
      page = Page.find(document.id)
      page.relevance = relevance
      input[:pages] << page
    end

    input[:pages] = input[:pages].sort_by(&:relevance).reverse
    Success(input)
  end

  # helper methods

  def create_term_counts(terms)
    term_count_hash = {}
    terms.group_by(&:page_id).each do |page_id, terms|
      term_count_hash[page_id] = terms.pluck(:name,:count).to_h
    end

    term_count_hash
  end
end