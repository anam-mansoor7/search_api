desc 'Consumes pages from Wikipedia'
task save_wiki_page_text: :environment do
  Command::SavePageText.new.call(url: 'List_of_countries_and_dependencies_by_population')
end
