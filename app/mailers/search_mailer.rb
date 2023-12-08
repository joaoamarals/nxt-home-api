class SearchMailer < ApplicationMailer
  def new_match
    search = params[:search]
    @home_ad = params[:home_ad]
    mail(to: search.user.email, bcc: 'j.amaral.s@gmail.com', subject: 'New match!')
  end
end
