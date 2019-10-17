class Command::SearchPages
  include Dry::Transaction

  step :validate_query
  step :parse_query
  step :lemmatize_query
  step :search_document_terms
  step :sort_terms_by_pages
  step :create_corpus

  def validate_query(input)
    return Failure('query field is required') unless input[:query].present?

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

  def sort_terms_by_pages(input)
    binding.pry
    input[:terms].group_by{|h| h[:page_id]}.each{|_, v| v.map!{|h| h[:name] = h[:count] } }
    input[:terms].group_by{|h| h[:page_id]}.each do |_, term|
      v.map!{|h| h[:name] = h[:count]}
    end

    Success(input)
  end

  def create_corpus(input)
    input[:corpus] = []

    binding.pry

    Page.find_each do |page|
      terms
      input[:corpus] << TfIdfSimilarity::Document.new('', term_counts: page.terms.slice(:name))
    end

    Success(input)
  end

  def add_query_to_corpus(input)
    input[:corpus] << TfIdfSimilarity::Document.new(input[:query])
    Success(input)
  end

  def create_similarity_matrix(input)
    input[:similarity_matrix] = TfIdfSimilarity::TfIdfModel.new(input[:corpus], library: :nmatrix).similarity_matrix

    Success(input)
  end
end