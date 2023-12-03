# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/search_mailer
class SearchMailerPreview < ActionMailer::Preview
  def new_match
    SearchMailer.with({ search: Search.last, home_ad: HomeAd.last }).new_match
  end
end
