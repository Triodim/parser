namespace :parser do
  desc "downloads site categories structure"
  task structure: :environment do
    Gatherer::CategoriesCollector.process.each do |category|
      Category.create(category)
    end
  end

  desc "downloads products"
  task download: :environment do
  end
end
