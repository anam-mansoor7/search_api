class Command::CrawlPages
  include Dry::Transaction

  BASE_URL = 'https://en.wikipedia.org'.freeze
  PAGE_TITLE_WEIGHT = 100.freeze

  step :get_main_page
  step :parse_linked_pages

  def get_main_page(input)
    input[:main_page] = Mechanize.new.get("#{BASE_URL}/wiki/#{input[:url]}")
    Success(input)
  end

  def parse_linked_pages(input)
    doc = Nokogiri::HTML(input[:main_page].body)
    lemmatizer = Lemmatizer.new

    doc.css('table.wikitable.sortable tbody tr td a').each do |row|
      title = row[:title]
      next unless title
      term_count_hash = Hash.new(0)
      puts title
      link = row[:href]
      next_web_page = input[:main_page].link_with(href: link).click
      term_count_hash[title] = PAGE_TITLE_WEIGHT
      doc_text = next_web_page.css('div#bodyContent').text

      page = Page.find_or_create_by(link: "#{BASE_URL}#{link}", title: title)

      fetch_tokens(doc_text).each do |token|
        token = lemmatizer.lemma(token)
        term_count_hash[token] += 1
      end

      persist_term_count(page, term_count_hash)
    end

    Success(input)
  end

  # Helper methods
  def persist_term_count(page, term_count_hash)
    term_count_hash.each do |key, value|
      term = Term.find_or_create_by(name: key, page: page)
      term.update(count: value)
    end
  end

  def fetch_tokens(text)
    stop_words = File.read(Rails.root.join('lib', 'stopwords', 'stopwords.txt'))
    text.downcase.scan(Term::WORD_REGEX) - stop_words.split(",")
  end
end