require 'rails_helper'

RSpec.describe 'applications_pets show' do
  before(:each) do
    @shelter = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet = @shelter.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter.pets.create!(name: 'Bear', breed: 'shorthair', age: 3, adoptable: true)

    @user = User.create!(full_name: 'Mike Piz', street_address: '13214 Yeet Rd.', city: 'Cleveland', state: 'OH', zipcode: 18907)
    @application = @user.applications.create!(status: 'In Progress', description: 'Give me it')
  end

  it "shows the application and all attributes without pets" do
    visit "/applications/#{@application.id}"

    expect(page).to have_content("User: #{@user.full_name}")
    expect(page).to have_content("Street Address: #{@user.street_address}")
    expect(page).to have_content("City: #{@user.city}")
    expect(page).to have_content("State: #{@user.state}")
    expect(page).to have_content("Zipcode: #{@user.zipcode}")
    expect(page).to have_content("\nApplying For: No pets applied for\n")
  end

  it "shows the application's pets" do
    association = ApplicationsPet.create(pet_id: @pet.id, application_id: @application.id )

    visit "/applications/#{@application.id}"

    expect(page).to have_content("Applying For: #{@pet.name}")

    expect(page).to have_link(@pet.name)
    expect(page).to have_content("In Progress")
  end

  it "clicks the applied for pet and redirects to its show page" do
    assocation = ApplicationsPet.create(pet_id: @pet.id, application_id: @application.id )

    visit "/applications/#{@application.id}"

    expect(page).to have_current_path("/applications/#{@application.id}")

    expect(page).to have_link(@pet.name)
    click_link(@pet.name)
    expect(page).to have_current_path("/pets/#{@pet.id}")
  end

  it "has a text box to search for pets per an in-progress status" do
    visit "/applications/#{@application.id}"

    expect(page).to have_button("Search")
  end

  it 'lists partial matches as search results and and an add to application button' do
    visit "/applications/#{@application.id}"

    fill_in 'search', with: "Mr."
    click_on("Search")

    expect(page).to have_content(@pet.name)
    expect(page).to have_content(@pet.shelter_name)
    expect(page).to have_content(@pet.breed)
    expect(page).to have_content(@pet.age)
    expect(page).to_not have_content(@pet.adoptable)
    expect(page).to have_button("Adopt this Pet")
  end

  it 'clicks add to application button and shows pet under application' do
    visit "/applications/#{@application.id}"

    fill_in 'search', with: "Mr."
    click_on("Search")
    click_on("Adopt this Pet")
    fill_in 'search', with: "Claw"
    click_on("Search")
    click_on("Adopt this Pet")

    expect(page).to have_content("Applying For: #{@pet.name}, #{@pet_2.name}")

    expect(page).to have_current_path("/applications/#{@application.id}")
  end

  it 'has a submission form with a description box and submit button' do
    assocation = ApplicationsPet.create(pet_id: @pet.id, application_id: @application.id )
    assocation = ApplicationsPet.create(pet_id: @pet_2.id, application_id: @application.id )
    assocation = ApplicationsPet.create(pet_id: @pet_3.id, application_id: @application.id )

    visit "/applications/#{@application.id}"

    expect(page).to have_content("Submit Application:")

    fill_in 'description', with: "This is the world's fluffiest dog. The other animals are for my deep need for affection. Give me it now."
    click_on('Submit')

    expect(page).to have_content("Application Status: Pending")
    expect(page).to have_current_path("/applications/#{@application.id}")

    expect(page).to have_no_button("Search")

    expect(page).to have_content("Applying For: #{@pet.name}, #{@pet_2.name}, #{@pet_3.name}")

  end

  it 'does not show submit application if no pets are on application' do
    visit "/applications/#{@application.id}"

    expect(page).to_not have_content("Submit Application:")
  end
end
