Simply Authem Authentication Engine
===================================

## Do you ever say any of the following when setting up authentication?

- I need authentication setup immediately...like yesterday
- I don't want to mess with setting up a users table or even touching my database. In fact, I don't want to make many authentication decisions at this point.  But I do need my User model to act like an ActiveRecord model.
- I need to be able to easily add fields to my User/Account model.
- I don't want to mess with setting up a Sessions controller and associated routing (`login_path`, `logout_path`, etc.)
- I need conventional method names available (`current_user`, `logged_in?`, `authorized?`) to be able to upgrade to a more robust system (Authlogic, Clearance, Restful Authentication) with little to no change to my application.
- I have less than 10 users to authenticate.
- I need to be able to authenticate on the email or username or login or email and username or any other field.
- I don't want anything other than a tiny yaml configuration file within my application code.
- I need to prototype something very quickly.
- I need a plugin/engine that makes me laugh when I say it out loud.

If so, give Simply Authem a try.  

## INSTALLATION

### 1. Install the [`active_hash`](http://github.com/zilkey/active_hash) gem and add to environment.rb
    
    sudo gem install zilkey-active_hash
    
    # in config/environment.rb
    config.gem "zilkey-active_hash", :lib => "active_hash", :source => 'http://gems.github.com'
    
### 2. Install the Simply Authem engine

    script/plugin install git://github.com/baldwindavid/simply_authem.git
    
### 3. Include SimplyAuthemSystem in ApplicationController
    
    class ApplicationController < ActionController::Base
      include SimplyAuthemSystem

### 4. Inherit your user model from SimplyAuthemUser
    
**Note:** This model does not have to be named User.  This could be Account, Person, etc.

    class User < SimplyAuthemUser
    
### 5. Add `login_required` as a `before_filter` to any controllers

    class EventsController < ApplicationController
      before_filter :login_required, :except => [:index]
      
You also have the `authorized?` method which can be overridden per controller.
      
### 6. Run the `simply_authem` generator

    script/generate simply_authem
    
The generator simply creates a yaml file (`config/simply_authem.yml`) that will setup your user model and authentication.
Here are the contents of the sample file (it can be much more simple or complex) if you would rather create it yourself...

    authentication_fields: 
      - email
      - username
    users:
      -
        id: 1
        email: someone@somewhere.com
        username: someone
        password: whatever
        firstname: John
        lastname: Doe
        active: true
      -
        id: 2
        email: someone_else@somewhere.com
        username: someone_else
        password: whatever
        firstname: Jack
        lastname: Handey
        active: false

        
Your file may be as simple as this for a single user authenticated by email...

    authentication_fields: 
      - email
    users:
      -
        id: 1
        email: jim@domain.com
        password: somepassword
        

## Authentication Fields

The authentication fields are just the field names that should be authenticated.  You can list either one or two fields and the field names can be whatever you want (email, username, login, etc.).

## Users

Add any additional fields and users that you need.  The only fields that are necessary are `id`, `password`, and the field name/s listed under `authentication_fields`.  

### ActiveRecord-ish

The users in the yaml file will work mostly like a real ActiveRecord model even though there is no database table.  This functionality is provided by the [`active_hash`](http://github.com/zilkey/active_hash) gem noted in the installation instructions.

ActiveHash objects implement enough of the ActiveRecord api to satisfy most common needs. For example:

    User.all             # => returns all User objects
    User.count           # => returns the length of the .data array
    User.first           # => returns the first User object
    User.last            # => returns the last User object
    User.find 1          # => returns the first User object with that id
    User.find [1,2]      # => returns all User objects with ids in the array
    User.find :all       # => same as .all
    User.find :all, args # => the second argument is totally ignored, but allows it to play nicely with AR
    User.find_by_id 1    # => find the first object that matches the id
    
**Dynamic Finders** - It also gives you a few dynamic finder methods. For example, if you defined :age as a field, you'd get:

    User.find_by_age 30      # => returns the first object matching that name
    User.find_all_by_age 30  # => returns an array of the objects with matching names
    
**Associations** - You can even use `belongs_to` and `has_many` associations. I added the `has_many` functionality and it is limited the simplest cases, but supports the `:class_name` and `:foreign_key` options.
    
    class User < SimplyAuthemUser
      has_many :events
      
**Accessor and Boolean Methods** - Just like in ActiveRecord, fields added in the yaml file will automatically get an accessor method and boolean version of said method.  

So if you were to define :age in the yaml file you would get...

    current_user.age
    
And if you defined :verified you could use the handy boolean method...

    current_user.verified?

## Helper Methods

- `logged_in?`
- `current_user`


### Credits

There is certainly nothing ground-breaking here as most of the thoughts and code can be traced back to a lot of different systems...

- Ariejan de Vroom - [`super-simple-authentication`](http://github.com/ariejan/super-simple-authentication)
- Rick Olson - [`restful-authentication`](http://github.com/technoweenie/restful-authentication)
- Jeff Dean - [`active_hash`](http://github.com/zilkey/active_hash)
- Ryan Bates - [`Railscasts - Super Simple Authentication`](http://railscasts.com/episodes/21-super-simple-authentication)


Copyright (c) 2009 David Baldwin, released under the MIT license