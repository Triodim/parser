namespace :parser do
  desc "downloads site categories structure"
  task structure: :environment do
    Gatherer::CategoriesCollector.new.process.each do |category|
      Category.create(category)
    end
  end

  desc "downloads products"
  task download: :environment do
    urls = Category.pluck(:url)
    products = Gatherer::ProductsCollector.new(urls).process
    products.each do |(url, products_data)|
      category = Category.find_by(url: url)
      # todo: handle case when category is not found
      products_data.each do |pd|

      end
    end
  end
end
