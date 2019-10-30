class Command::SavePageText
  include Dry::Transaction

  BASE_URL = 'https://en.wikipedia.org'.freeze

  step :save_page_text

  def save_page_text(input)
    main_page = Mechanize.new.get("#{BASE_URL}/wiki/#{input[:url]}")

    doc = Nokogiri::HTML(main_page.body)
    doc.css('table.wikitable.sortable tbody tr td a').each do |row|
      title = row[:title]
      next unless title
      link = row[:href]
      next_web_page = main_page.link_with(href: link).click

      doc_text = clean_content(next_web_page.css('div#bodyContent').text)

      page = Page.find_or_create_by(link: "#{BASE_URL}#{link}", title: title)
      page.update(doc_text: doc_text)
    end

    Success(input)
  end

  # helper method

  def clean_content(raw_html)
    html = raw_html.encode('UTF-8', invalid: :replace, undef: :replace, replace: '', universal_newline: true).gsub(/\P{ASCII}/, '')
    parser = Nokogiri::HTML(html, nil, Encoding::UTF_8.to_s)
    parser.xpath('//script')&.remove
    parser.xpath('//style')&.remove
    parser.xpath('//text()').map(&:text).join(' ').squish
  end
end