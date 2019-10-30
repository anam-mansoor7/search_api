class Command::SearchPagesByTsVector
  include Dry::Transaction

  MAX_QUERY_SIZE = 2000.freeze

  step :validate_query
  step :search_documents

  def validate_query(input)
    return Failure('query field is required') unless input[:query].present?
    return Failure("Length of query should be less than #{MAX_QUERY_SIZE}") if input[:query].length > MAX_QUERY_SIZE

    Success(input)
  end

  def search_documents(input)
    input[:pages] = Page
      .select("id, link,
        ts_rank_cd(
          doc_text_vector,
          plainto_tsquery('#{input[:query]}')
        ) AS relevance"
      )
      .where("doc_text_vector @@ plainto_tsquery(:query)", query: input[:query])
      .order("relevance DESC")
    Success(input)
  end
end