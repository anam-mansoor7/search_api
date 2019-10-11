class Command::CrawlPages
  include Dry::Transaction

  BASE_URL = 'https://en.wikipedia.org/'.freeze
  WORD_REGEX = /\b[a-z]{3,16}\b/.freeze

  step :get_main_page
  step :parse_linked_pages

  def get_main_page(input)
    input[:main_page] = Mechanize.new.get("#{BASE_URL}/#{input[:url]}")
    Success(input)
  end

  def parse_linked_pages(input)
    doc = Nokogiri::HTML(input[:main_page].body)
    term_count_hash = Hash.new(0)

    doc.css('table.wikitable.sortable tbody tr td a').each do |row|
      title = row[:title]
      next unless title

      puts title
      link = row[:href]
      next_web_page = input[:main_page].link_with(:href => link).click
      term_count_hash[title] = 100
      doc_text = next_web_page.css('div#bodyContent').text

      page = Page.find_or_create_by(link: "#{BASE_URL}/#{link}", title: title)
      doc_text.downcase.scan(WORD_REGEX) {|word| term_count_hash[word] += 1 }
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
end