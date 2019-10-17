# README

The app downloads information from every country page listed under “Sovereign states and dependencies by population” found here: https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population and implements two
endpoints to search that information. It also adds a rake task that crawls the wikipedia page and stores the information in the database.

It has the following components:

*  Search using tf–idf similiarity matrix  
*  Search using term frequency count
*  Rake task to consume wikipedia pages


# Search using tf–idf similiarity matrix 

`/search/pages?query='query'`

This endpoint uses the TFIDF vector to find similarity between documents. 
Please read https://en.wikipedia.org/wiki/Tf–idf to get an indepth understanding of the concepts behind this.



# Search using term frequency count 

`/search/pages_by_term_count?query='query'`

This endpoint is just searching the terms in a document by using their frequency.

E.g query = 'chocolate ice cream'

Document 1 = 'i like chocolates. yesterday, i bought dark chocolates. chocolates chocolates chocolates'
Document 2= 'I like chocolate ice cream'
Document 3 = 'chocolate'

term_count for Document 1 for the query will be 5
term_count for Document 2 will be 3

result will be [document1, document2, document 3]

for search by `tf–idf similiarity matrix` , the result will return `Document 2` first and assign the same relevance to `Document 1` and `Document 3` which is much more accurate
then searching by term count

# Rake task to consume wikipedia pages

`rake consume_wiki_pages`

The rake task performs the following steps:
1.  Get text from wikipedia page
2.  Remove stopwords from that text
3.  Tokenize the text
4.  performs [lemmatization](https://nlp.stanford.edu/IR-book/html/htmledition/stemming-and-lemmatization-1.html) on the text and computes term count frequency hash
5.  Stores that information in the database

# Database structure

- A table called `pages` with attributes; title, link, created_at and updated_at
- A table called `terms` with attributes; name, count and page_id

There is a one to many relationship between the two tables;

A `page` can have many `terms`

Each page in the database represents a page on wikipedia and each term represents the word on that page.

The search is quite fast as there is an index on the name field of the terms table. Also, becasue the term count hash is being pre computed and stored in the database

# Limitations

- To fetch the latest changes from wikipedia, rake task needs to be executed again
- Rake task is not removing terms from the databse if its removed from wikipedia page
- Rake task is quite slow 
- Rake task can use some cleaning up
- Add specs for the rake task

# Getting started

* Database creation

`rake db:create`

* Database initialization

`rake db:migrate`

* Populate data 

`rake consume_wiki_pages`

* How to run the test suite

`rspec spec/`

# Dependencies
* mechanize
* dry-transaction
* lemmatizer
* tf-idf-similarity
* nmatrix

