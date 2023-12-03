class SearchMailer < ApplicationMailer
  def new_match
    search = params[:search]
    @home_ad = params[:home_ad]
    mail(to: search.user.email, subject: 'New match!')
  end
end
