class ApplicationsPetsController < ApplicationController
  def update
    application = Application.find(params[:application_id])
    pet = Pet.find(params[:pet_id])
    application.pets << pet
    application.save

    redirect_to "/applications/#{application.id}"
  end
end
