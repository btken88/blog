# Auth with Rails, Part 2

In my last blog post, I reviewed how we can use a Rails backend with the bcrypt gem to securely store passwords when users sign up. In this post, we'll talk about how we can store a user's information in browser localStorage using JSON Web Tokens (JWT) in order to both persist login information and later authorize a user for certain paths and actions.

## Create a Route and Controller

The first step to logging a user in is creating the routes and logic on the backend to check if the user exists and if their password is correct. To make this as secure as possible, we want all of our login requests to be **POST** requests, not GET requests. In our `./config/routes.rb` file we need to create a new route for our users to log in.

## Authenticate the User

As you can see, we will also need to make a controller called `authentication` with a `login` route. To do this we'll simply run `rails g controller authentication` and then open up that file. Inside our new Authentication Controller we're going to need to check several things before confirming a user's account and logging them in. First, we need to see if the user even exists by using `User.find_by()` to check what was sent in the login request (`params[:username]`) against the `:username` column of our database. If there's no user, we'll send back an error message along with an unauthorized http status.

If there is a user with that username, next we want to check the password they sent over. The bcrypt gem gives us a simple, built-in way to do so - `@user.authenticate(params[:password])`. This has bcrypt take the password sent by the user(`params[:password]`), hash it like when it was stored, and compare the current hash with the saved hash. If the two hashes match, we know the password was correct. If they dont, we will again send back an error message with an unauthorized http status.

## Create a Secure Token

Once we've confirmed that the user entered the correct password, we're going to send the user a JSON Web Token (or JWT - pronounced jawt) with whatever data we want to store for reference. This is going to require another gem in our Rails app - jwt; run `bundle add jwt` and `bundle install` it to get set up. This lets us create a token using `JWT.encode(payload, secret)`, which takes whatever data we want to send (the payload) and hashes it along with some other identifying information using a "secret." The secret is just a 256 bit key which can be a random string of your own or, more securely, you can use Rails' built-in `application.secret_key_base`, which is randomly generated when you create the Rails app.

## Store a Token to Persist Login

Because we will generally use a user's id to find them in the database, that's what we've included in the payload. If you also wanted to include some other information, you could certainly do so, but we won't be decoding the token on the frontend. Just think of the information we send here as being used for identification purposes - it's like a handstamp at the club. Finally, when a user has successfully logged in, we will send them their token to be stored on the front end. In order to use this on the frontend, we simply have to save the token to localStorage as shown below (assuming you are using a javascript-based front end):

To save the token, we use a javascript method natively available to us - `localStorage.setItem()` allows you to store data in the browser's built-in local storage. To use it, we provide two arguments - a string we want to name the stored data, and whatever we want to store. Now that we have stored the login token, we can use it both to authorize access to data on the backend, and to create protected paths on the frontend. We'll talk about how to authorize users for access to backend resources in the next post.
