class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :first_time_visit, unless: -> { session[:first_visit] }

  # En la primera visita configuro cookies para realizar la solicitud correctamente
  def first_time_visit
    session[:first_visit] = 1
    session[:expire] = Time.now
    @first_visit = true
  end
end
