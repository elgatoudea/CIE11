class InteractionController < ApplicationController
  def new

    # Solicito el token de autorización solo si es necesario
     # Si el parámetro de sesión no ha sido inicializado
     # O si ha pasado una hora desde que se inicializó
    if @first_visit or Time.now >= session[:expire]
      # Proceso de autenticación
      response = RestClient.post 'https://icdaccessmanagement.who.int/connect/token',
                                  {
                                      scope: 'icdapi_access',
                                      grant_type: 'client_credentials',
                                      client_id: '5b967c45-ad6a-4ffd-9d01-69cb1e34c09e_2ce9ad47-3ecb-416c-b95b-6b598f462cd5',
                                      client_secret: '4mx7I0oCyuZJRJ4oUe4XnTxQw6mUh0wFaLtjSs5eZIM='
                                  }
      # El token caduca después de una hora
      session[:expire] = Time.now + 1.hour

      # Analizando la respuesta
      @response = JSON.parse(response)
      session[:token] = @response["access_token"]

    end
  end

  def create
  end

  def show
    # construye el uri con el parámetro deseado
     # Si no se ha pasado el parámetro de búsqueda, volver a la página anterior
    if params[:Buscar] == ""
      redirect_to interaction_new_path, notice: 'Introduzca un parámetro de búsqueda!'
    else
      response = HTTParty.get("http://id.who.int/icd/entity/search?q={#{params[:Buscar]}}", headers: {
        "Authorization": "Bearer #{session[:token]}",
        "Accept" => "application/json",
        "Accept-Language": "es",
        "API-Version": "v2"
      })
      @response = JSON.parse(response.body)
    end
  end

end
