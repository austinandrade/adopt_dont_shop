class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
      if params[:search].present? 
        @pets = Pet.adoptable.search(params[:search]) - @application.pets
      else
        @pets = Pet.adoptable - @application.pets
      end
  end

  def new
  end

  def create
    user = User.create(user_params)
    application = Application.new(description: application_params[:description],
                                  user_id: user.id,
                                  id: application_params[:id])
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:alert] = "Error: Please Fill in All Fields"
      redirect_to '/applications/new'
    end
  end

  def update
    application = Application.find(params[:id])
    application.update(description: application_params[:description],
                       user_id: application.user_id,
                       status: 'Pending')
    redirect_to "/applications/#{application.id}"
  end

  private

  def application_params
    params.permit(:user_id, :description, :status)
  end

  def user_params
    params.permit(:full_name, :street_address, :city, :state, :zipcode)
  end
end
