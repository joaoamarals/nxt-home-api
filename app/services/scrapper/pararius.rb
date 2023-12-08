# frozen_string_literal: true

module Scrapper
  # Scrapper for Pararius website to get apartments in the Netherlands
  class Pararius
    BASE_URL = 'https://www.pararius.com/apartments'

    CITIES = %w[amsterdam rotterdam den-haag utrecht eindhoven groningen
                tilburg breda haarlem delft leiden maastricht].freeze

    # @param [String] city
    # @param [Integer] page
    def self.call(city:, page: nil)
      new.call(city:, page:)
    end

    def call(city:, page: nil)
      response = HTTParty.get(build_url(city:, page:), build_headers)
      @document = Nokogiri::HTML(response.body)
      parsed_ads
    end

    private

    def build_url(city:, page:)
      url = "#{BASE_URL}/#{city}"
      page ? "#{url}/page-#{page}" : url
    end

    def build_headers
      {
         'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
         'User-Agent' =>  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
         'Accept-Encoding' =>  'gzip, deflate, br',
         'Accept-Language' =>  'en-GB,en-US;q=0.9,en;q=0.8',
         'referer' => 'https://www.google.com/',
         'cookie' => 'fl_mgc=DBIfBQeuoqemLBvyZIjSgKBAfnqVcwsZGaVMkJFvTeagCqrW; latest_search_locations=%5B%22rotterdam%22%5D; PHPSESSID=ujorv9bkiauag89tmqoc9r5i9s; _ga=GA1.1.1700578307.1702034376; OptanonAlertBoxClosed=2023-12-08T11:30:50.746Z; eupubconsent-v2=CP2dxBgP2dxBgAcABBENAdEsAP_gAEPgAChQg1NX_H__bW9r8Xr3aft0eY1P99j77uQxBhfJE-4FyLvW_JwXx2EwNA26tqIKmRIEu3ZBIQFlHJHURVigaogVryHsYkGchTNKJ6BkgFMRI2dYCF5vmYtj-QKY5_p_d3fx2D-t_dv83dzzz81Hn3f5f2ckcKCdQ58tDfn9bRKb-5IO9-78v4v09l_rk2_eTVn_pcvr7B-uft87_XU-9_fAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEQagCzDQqIA-yJCQi0DCKBACIKwgIoFAAAAJA0QEAJAwKdgYBLrCRACBFAAMEAIAAUZAAgAAEgAQiACQAoEAAEAgEAAAAAAgEADAwADgAtBAIAAQHQMUwoAFAsIEiMiIUwIQoEggJbKBBICwQVwgCLLAigERMFAAgCQAVgAAAsVgMASAlYkECWUG0AABAAgFFKFQik-MAQwJmy1U4om0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAACAA.f_wACHwAAAAA; fl_ctx=eyJhbGciOiJkaXIiLCJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwidHlwIjoiSldUIn0..Xb15ZE4qOLhrwdyQefXysw.XnI6L9lZMN6QLUaFSbqySa_c3j66O32Ig_KgbWnmJaEW3wThiz00YRiPpHoavlcAGwFNk_3hOPdud6PT6tAhRg4gEZB7rzUIJCRCWzgHQg36gJvywKdNPz326lPCO71g82-5LLvrC8-71OqBZZY2nsiwoxgmW06Dk7pY7k8oZeciY32YM9XJob9r9X0Q-mJjpfU1q3BuC5Kl3x_zFUHiv9xauriWk1jrabclI7gj5IreCHjqe5cwudsqonlb-8jJrG8_JLVhGROMtq-k1_Qe6PsBmPK5570ADF2nu_HkTEuzGSf9_EozhY0IN8O7e8_VXgZJ1gNJQy-UNBawhAKBfSDFQrmkycqZjqGfEcvZC83tF8MjHNOgO_Q7TuT7Ahr0bxC19LWFmWNavHs7j89fdVHkdV2jC_NyD7Btj3-b0F2qp_owCgJ3oK9_hY4GbMIiYJpd6pWQSxzkOW-oDOjpcnbmaHwczerXEjdVC3wwoDfcdhMTSgWLOT_7anzpfpgUPlynPxEVPnaXcQMUxYmXbmhLk2xC2a9kLgCTvK9TNqiWRX6wi5aYpQ0L8hI0WGlAiIPJfdRYDEWEm5-RVQjQY5jVgtEYqqOxjvl_LtrAC4BvDKaJT90xqbEMZGt9nl5Kahz9z1mW2-Ym6AcyYyocHackPatEIA_ugje6cS4jKE81w_xuuAQID1syT9kIL7GiqFWRzH71JHJ-KR6m6BaG0_46T7YlgF6Kne-pgTOmJ4BQrgf4dH4Xm-0gbl8lra0xA1DVWZelFk1EnLzRE4UQxa3D5Eogxq7dsWA8lVbOhjSOQSbJCgpU-TWhDLpgVhruHAX2s-PtMWF43yrXOD4lpQ.QtDjjYa2ujqh5v7wqiGj66yUmzzwu2gmpY3o44EzJ0s; OptanonConsent=isGpcEnabled=0&datestamp=Fri+Dec+08+2023+12%3A38%3A32+GMT%2B0100+(Central+European+Standard+Time)&version=202310.1.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=1513e616-3db9-45e9-b437-b4b6c12bd6c9&interactionCount=2&landingPath=NotLandingPage&groups=C0003%3A1%2CC0002%3A1%2CC0004%3A1%2CC0001%3A1%2CV2STACK42%3A1&geolocation=NL%3BZH&AwaitingReconsent=false; _ga_V649BZ47DJ=GS1.1.1702034375.1.1.1702035512.48.0.0'
       }
    end

    def parse_page(page)
      response = HTTParty.get("#{BASE_URL}?page=#{page}")
      @document = Nokogiri::HTML(response.body)

      parsed_ads
    end

    def parsed_ads
      home_ads.map do |home_ad|
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
