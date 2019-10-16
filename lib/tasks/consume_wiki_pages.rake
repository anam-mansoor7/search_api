desc 'Consumes pages from Wikipedia'
task consume_wiki_pages: :environment do
  Command::CrawlPages.new.call(url: 'List_of_countries_and_dependencies_by_population')
end
