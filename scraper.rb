require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)

  base_url = "https://www.imdb.com"

  movies_urls = []
  html_doc.search('.titleColumn a').first(5).each do |url|
    movies_urls << base_url + url.attributes["href"].value
  end

  movies_urls
end


REGEX = /(?<title>.*).\((?<year>\d{4})\)$/

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)


  title_year = html_doc.search('h1').text.strip
  title = title_year.match(REGEX)[:title]
  year = title_year.match(REGEX)[:year]


  return {
      title: title.strip,
      year: year.to_i,
      storyline: html_doc.search('.summary_text').text.strip,
      director: html_doc.search('.credit_summary_item a').first.text,
      cast: html_doc.search('.credit_summary_item a')[4..6].map(&:text)
  }
end

