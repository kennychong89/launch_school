ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"
require "fileutils"

require_relative "../app"

class ContactsListTest < Minitest::Test
  include Rack::Test::Methods
  
  def app 
    Sinatra::Application  
  end
 
  def setup
    FileUtils.mkdir_p(data_path)
    File.open(File.join(data_path, "users.yaml"), "w") do |file|
      file.write([{:username => "kennychong89", 
                   :password => "12345", 
                   :contacts => [{:id => "0", :first_name => "John", :last_name => "Snow"},
                                 {:id => "1", :first_name => "Michael", :last_name => "Scott", :email => "mkscoot@gmail.com"}
                                ]}].to_yaml)  
    end
  end
  
  def teardown
    FileUtils.rm_rf(data_path)
  end

  def test_home_redirect_to_sign_in_page
    # Criteria: user is not logged in
    # Expected result: the user should see the sign in page
    # Request method: GET
    # Response: A redirect
    get "/"
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Please Sign In"
  end
  
  def test_home_redirect_to_contact_page
    # Criteria: user is logged in
    # Expected result: the user should see the contacts page
    # Request method: GET
    # Response: A 301 redirect
    get "/", {}, { "rack.session" => { username: "kennychong89", contacts: [] } }
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "New Contact"
  end
  
  def test_signin_page_user_not_signed_in
    # Criteria: user is not signed in
    # Expected result: the user should see the sign in page
    # Request method: GET
    # Response: A 200 ok
    get "/signin"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Please Sign In"
  end
  
  def test_signin_page_user_signed_in
    # Criteria: user is signed in
    # Expected result: the user should be redirect to contacts page
    # Request method: GET
    # Response: A 301 redirect
    get "/signin", {}, { "rack.session" => { username: "kennychong89", contacts: [] } }
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "New Contact"
  end
  
  def test_signin_user_valid_credentials
    # Criteria: 
      # - user enters a valid username (e-mail) and password
      # - user is already registered into the system
    # Expected result:
      # - the user should see a message that he is logged in
      # - the user should see the contacts page
    # Request method: POST
    # Response: A 200 ok
    post "/signin", { username: "kennychong89", password: "12345" }
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_includes last_response.body, "New Contact"
  end
  
  def test_signin_user_missing_username
    # Criteria: 
      # - user enters an empty username with correct password
      # - user is already registered into the system
    # Expected result:
      # - the user should see a message that he is missing username
      # - the user should see the signin page again
    # Request method: POST
    # Response: A 401 unauthenticated
    post "/signin", { username: "", password: "12345" }
    assert_equal 401, last_response.status
    assert_includes last_response.body, "Invalid username or password. Please try again"
  end
  
  def test_signin_user_missing_password
    # Criteria: 
      # - user enters an valid username with empty password
      # - user is already registered into the system
    # Expected result:
      # - the user should see a message that he is missing password
      # - the user should see the signin page again
    # Request method: POST
    # Response: A 401 unauthenticated
    post "/signin", { username: "kennychong89", password: "" }
    assert_equal 401, last_response.status
    assert_includes last_response.body, "Invalid username or password. Please try again"
  end 
  
  def test_signin_user_enter_invalid_username
    # Criteria: 
      # - user enters an invalid username with valid password
      # - user is already registered into the system
    # Expected result:
      # - the user should see a message that either his username or password is wrong
      # - the user should see the signin page again
    # Request method: POST
    # Response: A 401 unauthenticated
    post "/signin", { username: "kennychong88", password: "12345" }
    assert_equal 401, last_response.status
    assert_includes last_response.body, "Invalid username or password. Please try again"
  end
  
  def test_signin_user_enter_invalid_password
    # Criteria: 
      # - user enters an valid username with invalid password
      # - user is already registered into the system
    # Expected result:
      # - the user should see a message that either his username or password is wrong
      # - the user should see the signin page again
    # Request method: POST
    # Response: A 401 unauthenticated
    post "/signin", { username: "kennychong88", password: "1234" }
    assert_equal 401, last_response.status
    assert_includes last_response.body, "Invalid username or password. Please try again"
  end
  
  def test_signout_user
    # Criteria: user is signed-in 
    # Expected result:
      # - the user should see a message that he signed out
      # - the user should redirect to the sign-in page
    # Request method: POST
    # Response: A 200 okay, then a 301 redirect
    post "/signout", {}, { "rack.session" => { username: "kennychong89" } }
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "You have signed out"
    
    get "/contacts"
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Please Sign In"
  end
  
  def test_signout_user_no_sign_in
    # Criteria: user is not signed in and wants to sign out 
    # Expected result:
      # - the user should be redirected to sign in page
    # Request method: POST
    # Response: A 200 okay, then a 301 redirect
    post "/signout"
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Please Sign In"
  end
 
  def test_register_user_page
    # Criteria: user is not signed-in
    # Expected result:
      # - the user should see the register page
      # - the register page should have form to enter username and password
    # Request method: GET
    # Response: A 200 okay
    get "/register"
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Register Your Account"
  end
  
  def test_register_user_success
    # Criteria: user enters a valid username and password
    # Expected result:
      # - the user should see that a message that he has signed in successfully
      # - the user should see the contact page
    # Request method: POST
    # Response: A 200 okay
    post "/register", { username: "DavidC89", password: "Imready" }
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Please Sign In"
  end
  
  def test_register_user_fail_empty_username
    # Criteria: user enters an empty username and password
    # Expected result:
      # - the user should see a message the he needs to enter a username
      # - the user should see the register page again.
    # Request method: POST
    # Response: A 400 bad request
    post "/register", { username: "", password: "Imready" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password cannot be empty"
  end
  
  def test_register_user_fail_empty_password
    # Criteria: user enters a username and empty password
    # Expected result:
      # - the user should see a message the he needs to enter a password
      # - the user should see the register page again.
    # Request method: POST
    # Response: A 400 bad request
    post "/register", { username: "happytrees", password: "" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password cannot be empty"
  end
  
  def test_register_user_fail_duplicate_username
    # Criteria: user enters a username that already exists and password
    # Expected result:
      # - the user should see a message the he needs to enter a different username
      # - the user should see the register page again.
    # Request method: POST
    # Response: A 400 bad request 
    post "/register", { username: "kennychong89", password: "12" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username already exists"
  end
  
  def test_register_user_fail_add_lead_whitespace_username
    # Criteria: user enters a username adding whitespace
    # Expected result:
      # - the user should see a message the he needs to enter a different username
      # - the user should see the register page again.
    # Request method: POST
    # Response: A 400 bad request
    post "/register", { username: " kennychong89", password: "12" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password cannot contain whitespaces"
  end
  
  def test_register_user_fail_add_whitespace_username
    post "/register", { username: " kenny chong89", password: "12" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password cannot contain whitespaces"
  end
  
  def test_register_user_fail_add_lead_whitespace_passwrod
    post "/register", { username: "kennychong819", password: " 12" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password cannot contain whitespaces"
  end
  
  def test_register_user_fail_add_whitespace_password
    post "/register", { username: "kennychong819", password: "12 " }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password cannot contain whitespaces"
  end
  
  def test_register_user_fail_add_over_100_characters
    post "/register", { username: "k" * 121, password: "123" }
  
    assert_equal 400, last_response.status
    assert_includes last_response.body, "Username or password exceeded 100 characters"
  end
  
  def test_contact_page_displays_contacts
    # Criteria:
      # - user is signed in as "kennychong89":
        # - "kennychong89" has 2 contacts (manually added):
          # - 1st contact: first name is "John". Last name is "Snow"
          # - 2nd contact: first name is "Michael". Last name is "Scott"
    # Expected result:
        # - contacts page should display the 2 contacts names. 
        # - the names should be a link to the contact's information.
    # Request method: GET
    # Response: A 200 okay
    post "/signin", { username: "kennychong89", password: "12345" }
    
    assert_equal 302, last_response.status
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "John, Snow"
    assert_includes last_response.body, "Michael, Scott"
  end
  
  def test_add_new_contact_page
    # Criteria: user is signed in
    # Expected result:
      # - the user should see the add new contact page
    # Request method: GET
    # Response: A 200 okay
    get "/contacts/add", {}, { "rack.session" => { username: "kennychong89" } }
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Enter New Contact"
  end
  
  def test_add_new_contact_file
    # Criteria: 
      # - user is signed in.
      # - user enters first name, last name, e-mail of contact
    # Expected result:
      # - the contact data is saved to yaml file. 
      # - test this by signing out and signing back in
    # Request method: POST
    # Response: A 200 okay
    post "/signin", { username: "kennychong89", password: "12345" }
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
  
    post "/contacts", 
    { first_name: "John", last_name: "Wayne", email: "jwayne49@gmail.com" }
  
    post "/contacts",
    { first_name: "John", last_name: "Mayer", email: "jmayer@gmail.com", state: "US" }
    
    post "/signout"
    post "/signin", { username: "kennychong89", password: "12345" }
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "John, Wayne"
    assert_includes last_response.body, "John, Mayer"
  end

  def test_add_new_contact_session
    # Criteria: 
      # - user is signed in.
      # - user enters first name, last name, e-mail of contact
    # Expected result:
      # - the user be redirected back to the contacts page
      # - the user should see a message indicating contact was added successfully
      # - the user should see the first name (optional last name) of the contact in the contact page 
    # Request method: POST
    # Response: A 200 okay
    post "/contacts", 
    { first_name: "Ben", last_name: "Hurst", email: "benhurst@gmail.com" }, 
    { "rack.session" => { username: "kennychong89", contacts: [] } }
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Ben Hurst has been added to your contacts"
    assert_includes last_response.body, "Ben, Hurst"
  end
  
  def test_add_new_contact_no_first_name
    # Criteria: 
      # - user is signed in.
      # - user enters last name, e-mail of contact, but no first name.
    # Expected result:
      # - the user be prompted by a message to enter the first name.
      # - the user should see the sign-in page again
    # Request method: POST
    # Response: A 400 error
    post "/contacts", 
    { first_name: "", last_name: "Hurst", email: "benhurst@gmail.com" }, 
    { "rack.session" => { username: "kennychong89", contacts: [] } }
    
    assert_equal 400, last_response.status
 
    assert_includes last_response.body, "Missing first name of contact"
  end
  
  def test_fetch_contact_info
    post "/signin", { username: "kennychong89", password: "12345" }

    get "/contacts/user/1"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Michael Scott"
    assert_includes last_response.body, "mkscoot@gmail.com"
  end
  
  def test_fetch_nonexistent_contact_info
    post "/signin", { username: "kennychong89", password: "12345" }
    
    get "/contacts/user/3"
    
    assert_equal 302, last_response.status
    get last_response["Location"]
    assert_includes last_response.body, "Cannot find user"
  end
  
  def test_edit_contact_info_page
    post "/signin", { username: "kennychong89", password: "12345" }
    
    get "/contacts/user/edit/1"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Edit Contact For Michael Scott"
  end
  
  def test_edit_nonexistent_contact_info_page
    post "/signin", { username: "kennychong89", password: "12345" }
    
    get "/contacts/user/edit/3"
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    assert_includes last_response.body, "Cannot find user"
  end
  
  def test_edit_contact_info
    post "/signin", { username: "kennychong89", password: "12345" }
    post "/contacts/user/edit/1", { first_name: "Mike", last_name: "Scot" }
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    assert_includes last_response.body, "Contact information has been updated"
    
    post "/signout"
    post "/signin", { username: "kennychong89", password: "12345" }
    
    get last_response["Location"]
    
    assert_includes last_response.body, "Mike, Scot"
  end
  
  def test_edit_unknown_contact_info
    post "/signin", { username: "kennychong89", password: "12345" }
    post "/contacts/user/edit/3", { first_name: "Mike", last_name: "Scot" }
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_includes last_response.body, "Cannot find user"
  end
  
  def test_edit_contact_info_missing_first_name
    post "/signin", { username: "kennychong89", password: "12345" }
    post "/contacts/user/edit/1", {first_name: "", last_name: "Scot", email: "greatscoot@gmail.com" }
    
    assert_equal 400, last_response.status
    
    assert_includes last_response.body, "Missing first name of contact"
  end
  
  def test_delete_contact
    post "/signin", { username: "kennychong89", password: "12345" }
    post "/contacts/user/remove/0"
    
    assert_equal 302, last_response.status
  
    get last_response["Location"]
    
    assert_equal 200, last_response.status
    
    assert_includes last_response.body, "Contact information has been deleted"
    refute_includes last_response.body, "John, Snow"
    
    post "/signout"
    post "/signin", { username: "kennychong89", password: "12345" }
    
    get last_response["Location"]
    
    refute_includes last_response.body, "John, Snow"
  end
  
  def test_delete_unknown_contact
    post "/signin", { username: "kennychong89", password: "12345" }
    post "/contacts/user/remove/3"
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    
    assert_includes last_response.body, "Cannot find user"
  end
end