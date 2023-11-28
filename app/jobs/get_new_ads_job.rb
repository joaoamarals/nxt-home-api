class GetNewAdsJob < ApplicationJob
  def perform(*args)
    Scrapper::Pararius::CITIES.each do |city|
      page = 1

      loop do
        puts "City: #{city} | Page: #{page}"
        no_of_existing_ads_per_page = 0

        sleep rand(1..4) * 0.01
        ads = Scrapper::Pararius.new.call(city:, page: page)

        ads.each do |ad|
          HomeAd.create!(uuid: ad[:id], elements: ad)
        rescue ActiveRecord::RecordNotUnique
          puts "Record already exists and no of existing ads per page was #{no_of_existing_ads_per_page}"
          existing_ad = HomeAd.find_by(uuid: ad[:id])
          no_of_existing_ads_per_page += 1 and next if existing_ad
        end

        break if no_of_existing_ads_per_page > 25

        page += 1
      end
    end
  end
end
