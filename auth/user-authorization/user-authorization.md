# Auth With Rails – The Thrilling Conclusion

In my last two posts, we looked at how to securely store a user's password on the backend, how to verify a user's password on login, and how to store a token using localStorage to later authorize a user. In this post we'll cover that final part - how to use the token stored in localStorage to check if someone is a verified user and to check their permissions for app access.

## Protecting the Front End

There are a couple ways we can use the stored token to protect/authorize access to the front end. The simplest is just checking if there's a token in localStorage before showing a page - this assumes that a person hasn't saved some random string in their localStorage with the same key we're checking for our token. If the token isn't there, we can either redirect them or conditionally render and error message. If we want to check that there is a token *and* that the token is valid before showing content, we'll have to send the token to our back end and check if it's valid.

## Send Back the Token

In order to see if a user has permission for information stored on the backend, we are going to have to send the token that *should* be in localStorage back to our server. We can do this in **any kind of fetch request** we make to the backend by adding the token as an authorization header on the HTTP request, as you can see below. We are using what's considered "bearer authorization," because we're sending the token saying "the *bearer* of this token is authorized for these actions."

## Check if the token is valid

We have a few options for where exactly to validate our token, but it has to happen in a controller. Assuming you want to use the same authorization method from several different controllers (for instance to check if a user is logged in), the best place to define the method is inside the application controller. Since all our other controllers inherit from that base class, we'll be able to call an authorization method defined there in any other controller.

### Get the token out of the request header

Our first step is to pull out the authorization header from the incoming HTTP request. Since the HTTP request comes in as a hash, we're going to reference the header as `request.headers["Authorize"]`, pulling out the value of our token from the authorization header. Since we sent the token over as `'Bearer ${tokenValue}'`, we have to split the string at the space and pull the token from index 1 in the resulting array. If there isn't a token, we know the user isn't authorized so we can send back an error response.

### Confirm the token is valid and find user

Once we've pulled the token out of the request header, we need to decode the token using JWT. The process is almost exactly the same as when we encoded it, we just pass in our secret and the token, and the result is the payload. If you recall, our secret is autiomatically created by Rails and stored in the app as `Rails.application.secret_key_base`. The result of decoding is going to be a hash *inside* an array, so we need to pull that hash out either using `[0]` or `.first`.

Next we try to find the user by their user id, saving the result to a global variable (this will be helpful later). If we can't find a user in our database with a matching user id, we'll send back an authorization error - note the syntax here seems a little odd. We're saying render this json *unless* you find a user.

### Using the authorization method

Inside any of our other controllers, we can now use the authorization method to confirm users are logged in by placing it as a `before_action`. We can either specify specific routes on the controller we want to authorize, or force authorization on all routes. One convenience of running the authorize method is that it gives us access to the user variable we set, meaning we can refer to @user without having to find the user again inside the specific controller. Since we have access to the user, if we had levels of authorization setup such as user and administrator, we could just check the user instance to see if they had the appropriate authorization levels before sending back information or granting access to a certain page.

And that's it! As simple as that, you can authenticate and authorize users using Rails, bcrypt, and JWT. You can use this same pattern for user auth in any language and device platform - the only thing that changes is syntax and where you store the token.