# frozen_string_literal: true

module Scrapper
  # Scrapper for Pararius website to get apartments in the Netherlands
  class Pararius
    BASE_URL = 'https://www.pararius.com/apartments/rotterdam'

    def call
      response = HTTParty.get(BASE_URL)
      @document = Nokogiri::HTML(response.body)

      parse_document
    end

    private

    def parse_document
      home_ads.each do |home_ad|
        parse_ad(home_ad)
      end
    end

    def home_ads
      @document.css('.search-list__item--listing')
    end

    def parse_ad(home_ad)
      link = link(home_ad)
      {
        title: title(home_ad),
        subtitle: subtitle(home_ad),
        price: price(home_ad),
        link:,
        features: features(home_ad),
        id: identifier(link)
      }
    end

    def title(home_ad)
      home_ad.css('.listing-search-item__title > a').text.strip
    end

    def subtitle(home_ad)
      home_ad.css('.listing-search-item__title + div').text.strip
    end

    def price(home_ad)
      home_ad.css('.listing-search-item__price').text.strip
    end

    def link(home_ad)
      home_ad.css('.listing-search-item__link--title').map { |link| link['href'] }[0]
    end

    def features(home_ad)
      features = home_ad.css('.illustrated-features__item')

      features.each_with_object({}) do |feature, agg|
        agg[feature_name(feature)] = feature.text.strip
      end
    end

    def identifier(link)
      link.split('/')[3]
    end

    def feature_name(feature)
      class_attr = feature.attribute_nodes.select { |attr| attr.name == 'class' }.first
      feature_attr(class_attr).split('--').last
    end

    def feature_attr(class_attr)
      class_attr.value.split(' ').select do |css_class|
        css_class.include?('illustrated-features__item--')
      end.first
    end
  end
end
