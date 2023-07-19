require 'httparty'
require 'nokogiri'
require 'csv'

CSV.open(
  filename = 'books.csv',
  mode = 'w+',
  **options = {
    write_headers: true,
    headers: %w[Title Price]
  }
) do |csv|
  50.times do |i|
    response = HTTParty.get("https://books.toscrape.com/catalogue/page-#{i + 1}.html")
    if response.code == 200
      puts response.body
    else
      puts "Error: #{response.code}"
    end

    document = Nokogiri::HTML(response.body)  # create a document object with the parsed body of the response.
    all_book_containers = document.css('article.product_pod') # use css method to select all book containers.
    all_book_containers.each do |container|
      title = container.css('h3 a').first['title']
      price = container.css('p.price_color').text.delete('^0-9.')
      book = [title, price]
      csv << book
    end
  end
end
