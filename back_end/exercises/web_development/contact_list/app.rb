require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

set(:auth) do |required|
  condition do
    if !logged_in? && required
      redirect '/signin'
    end
  end
end

helpers do 
  def logged_in?
    !session[:username].nil?
  end
  
  def username
    session[:username]
  end
  
  def contacts
    session[:contacts]
  end
end

def has_account?(username, password)
  @users.has_key?(username) && @users[username][:password] == password
end

def account_register_error?(username, password)
  message = if @users.has_key?(username)
              "Username already exists"
            elsif username.empty? || password.empty?
              "Username or password cannot be empty"
            elsif username.include?(" ") || password.include?(" ")
              "Username or password cannot contain whitespaces"
            elsif username.size > 100 || password.size > 100
              "Username or password exceeded 100 characters"
            end
  message
end

def create_session(username)
  session[:username] = username
  session[:contacts] = @users[username][:contacts]
end

def add_new_user(username, password)
  if !has_account?(username, password)
    @users[username] = { :password => password, :contacts => [] }
    write_account_to_file(username, password)
  end
end

def write_account_to_file(username, password)
  users = YAML.load_file(File.join(data_path, "users.yaml"))
  users.push({:username => username, :password => password, :contacts => []})
  File.open(File.join(data_path, "users.yaml"), 'w') { |f| f.write(users.to_yaml) } 
end

def write_contact_to_file(contact)
  users = YAML.load_file(File.join(data_path, "users.yaml"))
  
  users.each do |account| 
    account[:contacts].push(contact) if account[:username] == session[:username] 
  end

  File.open(File.join(data_path, "users.yaml"), 'w') { |f| f.write(users.to_yaml) }
end

def write_contact_to_session(contact)
  session[:contacts].push(contact)  
end

def write_updated_contact_to_file(new_contact)
  accounts = YAML.load_file(File.join(data_path, "users.yaml"))
  index = accounts.index { |account| account[:username] == session[:username] }

  if !index.nil?
     accounts[index][:contacts].each do |contact|
       contact.replace(new_contact) if contact[:id] == new_contact[:id]  
     end
  end
  
  File.open(File.join(data_path, "users.yaml"), 'w') { |f| f.write(accounts.to_yaml) }
end

def write_updated_contact_to_session(new_contact)
  session[:contacts].each do |contact|
    contact.replace(new_contact) if contact[:id] == new_contact[:id]  
  end
end

def remove_contact_from_file(contact_id)
  accounts = YAML.load_file(File.join(data_path, "users.yaml"))
  index = accounts.index { |account| account[:username] == session[:username] }
  
  if !index.nil?
    accounts[index][:contacts].delete_if { |contact| contact[:id] == contact_id }  
  end
  
  File.open(File.join(data_path, "users.yaml"), 'w') { |f| f.write(accounts.to_yaml) }
end

def create_contact(id)
  first_name = params[:first_name]
  last_name = params[:last_name]
  email = params[:email]
  home_phone = params[:home_phone]
  cell_phone = params[:cell_phone]
  work_phone = params[:work_phone]
  address_one = params[:address_one]
  address_two = params[:address_two]
  city = params[:city]
  zipcode = params[:zipcode]
  notes = params[:notes]

  {
    :id => id,
    :first_name => first_name,
    :last_name => last_name,
    :email => email,
    :home_phone => home_phone,
    :cell_phone => cell_phone,
    :work_phone => work_phone,
    :address_one => address_one,
    :address_two => address_two,
    :city => city,
    :zipcode => zipcode,
    :notes => notes
  }
end

def next_contact_id
  max = session[:contacts].map { |contact| contact[:id].to_i }.max || 0
  max + 1
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  users = YAML.load_file(File.join(data_path, "users.yaml"))
  @users = users.each_with_object({}) do |user, hash|
    hash[user[:username]] = { :password => user[:password], 
                              :contacts => user[:contacts] }
  end
end

get "/", :auth => true do 
  # if the signed-in user requests the home page, route should redirect to the
  # user's contacts list page.
  # if user is not signed in, send user to sign-in page.
  redirect "/contacts"
end

get "/contacts", :auth => true do
  @contacts = session[:contacts]
  
  # display list of user's contacts
  erb :contacts, layout: :layout
end

get "/signin" do
  # sends the user the sign-in page as a response if user is not signed in.
  # redirect user to home page if user is already signed in.
  redirect "/contacts" if logged_in?
  
  erb :signin, layout: :layout
end

get "/register" do
  # render the register page only if the user is not signed-in
  redirect "/contacts" if logged_in?
  
  erb :register, layout: :layout
end

post "/signin" do
  # validates the user's name and password
  # checks if user exists
  # checks if user has already signed-in
  # if the user is validated, redirect user to home page with the list of contacts rendered
  username = params[:username]
  password = params[:password]

  if has_account?(username, password)
    create_session(username) if !logged_in?
    redirect "/contacts"
  else
    status 401
    session[:error] = "Invalid username or password. Please try again"
    erb :signin, layout: :layout
  end
end

post "/signout", :auth => true do
  # signs the user out if not already signed out
  # redirect user back to sign-in page
  session.delete(:username)
  session[:message] = "You have signed out"
  redirect "/signin"
end

post "/register" do
  # create a new account for the user unless some problem with information
  # occured.
  # if there is an error, flash an error message to user and re-render the
  # template
  # if there is no error, flash a welcome message and redirect user to his
  # contact list
    
  # retrieve username and password
  username = params[:username]
  password = params[:password]
  error = account_register_error?(username, password)
  
  if error
    session[:error] = error
    status 400
    erb :register, layout: :layout
  else 
    add_new_user(username, password)
    session[:message] = "Your account has been successfully created. Please sign in."
    redirect "/signin"
  end
end

get "/contacts/add", :auth => true do
  # render the contract creation page.
  # flash a message if user is not signed-in.
  erb :new_contact, layout: :layout
end

get "/contacts/user/:id", :auth => true do
  # render the contact's information page
  # flash an error message if the contact cannot be found and re-render the contact page.
  # flash an error message if user attempts to access contact without signing-in. redirect him back to the sign-in page.
  contact_info = session[:contacts].select { |contact| contact[:id] == params[:id] }[0]

  if !contact_info.nil?
    @id = contact_info[:id]
    @first_name = contact_info[:first_name]
    @last_name = contact_info[:last_name]
    @email = contact_info[:email]
    @home_phone = contact_info[:home_phone]
    @cell_phone = contact_info[:cell_phone]
    @work_phone = contact_info[:work_phone]
    @address_one = contact_info[:address_one]
    @address_two = contact_info[:address_two]
    @city = contact_info[:city]
    @zipcode = contact_info[:zipcode]
    @notes = contact_info[:notes]
    
    erb :contact_profile, layout: :layout
  else
    session[:error] = "Cannot find user"
    redirect "/contacts"
  end
end

get "/contacts/user/edit/:id", :auth => true do
  # render the edit the contact's information page
  # flash an error message if the contact does not exist
  # flash an error message if user is not signed-in.
  contact_info = session[:contacts].select { |contact| contact[:id] == params[:id] }[0]
  if !contact_info.nil?
    @id = contact_info[:id]
    @first_name = contact_info[:first_name]
    @last_name = contact_info[:last_name]
    @email = contact_info[:email]
    @home_phone = contact_info[:home_phone]
    @cell_phone = contact_info[:cell_phone]
    @work_phone = contact_info[:work_phone]
    @address_one = contact_info[:address_one]
    @address_two = contact_info[:address_two]
    @city = contact_info[:city]
    @zipcode = contact_info[:zipcode]
    @notes = contact_info[:notes]
    
    erb :edit_contact, layout: :layout
  else
    session[:error] = "Cannot find user"
    redirect "/contacts"
  end
end

post "/contacts", :auth => true do
  # add the contact to user contacts.

  if params[:first_name].empty?
    session[:error] = "Missing first name of contact"
    status 400
    erb :new_contact, layout: :layout
  else 
    id = next_contact_id.to_s
    contact = create_contact(id)
    write_contact_to_file(contact)
    write_contact_to_session(contact)
  
    session[:message] = "#{params[:first_name]} #{params[:last_name]} has been added to your contacts"
    redirect "/contacts"
  end
end

post "/contacts/user/edit/:id", :auth => true do
  # update the contact's information
  # flash a message if contact does not exist
  # flash a message if user is not signed-in.
    
  contact_info = session[:contacts].select { |contact| contact[:id] == params[:id] }[0]

  if contact_info.nil?
    session[:error] = "Cannot find user"
    redirect "/contacts"
  elsif params[:first_name].empty?
      session[:error] = "Missing first name of contact"
      
      contact_info = session[:contacts].select { |contact| contact[:id] == params[:id] }[0]
      
      @id = contact_info[:id]
      @first_name = contact_info[:first_name]
      @last_name = contact_info[:last_name]
      @email = contact_info[:email]
      @home_phone = contact_info[:home_phone]
      @cell_phone = contact_info[:cell_phone]
      @work_phone = contact_info[:work_phone]
      @address_one = contact_info[:address_one]
      @address_two = contact_info[:address_two]
      @city = contact_info[:city]
      @zipcode = contact_info[:zipcode]
      @notes = contact_info[:notes]
    
      status 400
      erb :edit_contact, layout: :layout
  else
      contact = create_contact(params[:id])
      write_updated_contact_to_file(contact)
      write_updated_contact_to_session(contact)
      
      session[:message] = "Contact information has been updated"
      redirect "/contacts"
  end
end

post "/contacts/user/remove/:id", :auth => true do
  # delete the contact from list. 
  # flash a message if contact does not exist.
  # flash a message if user is not signed-in.
  contact_info = session[:contacts].select { |contact| contact[:id] == params[:id] }[0]
  
  if contact_info.nil?
    session[:error] = "Cannot find user"
    redirect "/contacts"
  else
    remove_contact_from_file(contact_info[:id])
    session[:contacts].delete_if { |contact| contact[:id] == contact_info[:id] }
    session[:message] = "Contact information has been deleted"
    redirect "/contacts"
  end
end

#TODO
get "/contacts/groups" do
  # not sure what route should do
end

get "/contacts/groups/:group_name" do
  # fetch contacts from given group
  # flash a message if user is not signed-in.
  # flash a message if group does not exists  
end

post "/contacts/groups/:group_name" do
  # add a new group given group_name
  # flash a message if user is not signed-in.
  # flash a message if group_name alreadys exists
end

post "/contacts/groups/:group_name/remove" do
  # remove the group from groups. should put contacts from that group into
  # a default group.
  # flash a message if user is not signed-in.
  # flash a message if group_name does not exist or is the default group. 
end

post "/contacts/groups/:group_name/:contact_id/add" do
  # add the contact to the the group
  # flash a message if user is not signed-in.
  # flash a message if group_name does not exist. 
end

post "/contacts/groups/:group_name/:contact_id/remove" do
  # remove contact from group and place it into default group
  # flash a message if user is not signed-in.
  # flash a message if group_name does not exist. 
end

post "/contact/search/" do
  # search contact based on criteria provided.
  # render page with search results.
end