module Gatherer
  class CategoriesCollector
    #for get english version
    HOME_PAGE = 'http://www.tvdirect.tv/sale-promotion?___from_store=en&___store=en'.freeze

    def initialize
      @page = Mechanize.new.get(HOME_PAGE)
    end

    def process
      @page.search('.category li.level0>a').map do |link|
        { title: link.text, url: link[:href] }
      end
    end
  end
end
