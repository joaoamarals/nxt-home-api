class SearchMailer < ApplicationMailer
  def new_match
    search = params[:search]
    @home_ad = params[:home_ad]
    mail(to: 'j.amaral.s@gmail.com', bcc: 'j.amaral.s@gmail.com', subject: 'New match!')
  end
end
