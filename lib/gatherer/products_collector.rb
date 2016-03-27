module Gatherer
  class ProductsCollector
    def initialize(urls)
      @urls = urls
      @mechanize = Mechanize.new
    end

    def process
      @urls.each_with_object({}) do |url, res|
        res[url] = []
        go_trough_to_pagination(setup_page(url)) do |page|
          res[url].concat(page.search('li.item').map { |item| parse_product(item) })
        end
      end
    end

    def setup_page(url)
      page = @mechanize.get(url)
      css = '.toolbar-bottom select[title="Results per page"] option'
      url = page.search(css).max_by { |node| node.text.to_i }[:value]
      @mechanize.get(url)
    end

    def go_trough_to_pagination(page)
      loop do
        yield(page)
        print '.'
        next_link = page.at('a.next')
        break if next_link.nil?

        page = @mechanize.get(next_link[:href])
      end
    end

    def parse_product(node)
      {
        price: node.at('span.price').text[/[\d,.]+/],
        title: node.at('h2.product-name').text.strip,
        sku: node.at('input[name="sku"]')[:value],
        url: node.at('h2.product-name a')[:href]
      }
    end
  end
end
