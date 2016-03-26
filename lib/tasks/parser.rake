namespace :parser do
  desc "downloads site categories structure"
  task structure: :environment do
    Gatherer::CategoriesCollector.process.each do |category|
      Category.create(category)
    end
  end

  desc "downloads products"
  task download: :environment do
    page = mechanize.get(category.search('div.toolbar-bottom select[title="Results per page"] option').last[:value])
    products = page.search('li.item')
    p = products.first
    price = p.at('span.price').text[/[\d,.]+/]
    title = p.at('h2.product-name').text.strip
    sku = p.at('input[name="sku"]')[:value]
    url = p.at('h2.product-name a')[:href]

    next_link = page.at('a.next')[:href]
    mechanize.get(next_link) if next_link

  end
end
