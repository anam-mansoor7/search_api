desc 'Consumes pages from Wikipedia'
task consume_wiki_pages: :environment do
  wiki_page = Mechanize.new.get('https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population')
  doc = Nokogiri::HTML(wiki_page.body)
  doc.css('table.wikitable.sortable tbody tr td a').each do |a|
    next unless a[:title]

    puts a[:title]
    title = a[:title]
    link = a[:href]
    p = wiki_page.link_with(:href => a[:href]).click
    doc_text = p.css('div#bodyContent').text
    frequency = Hash.new(0)
    doc_text.scan(/\b[a-z]{3,16}\b/) {|word| frequency[word] = frequency[word] + 1}

    page = Page.find_or_create_by(link: link, title: title)
    page.terms << convert_format(frequency)
  end
end

def convert_format(frequency)
  result = []
  frequency.each do |key, value|
    result << Term.new(name: key, count: value)
  end

  result
end
