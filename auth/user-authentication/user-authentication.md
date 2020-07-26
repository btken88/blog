# Auth^2 with Rails

## Secure User Authentication using bcrypt

When we create an app that is going to store information about different user or that has protected resources on the backend, it becomes especially important to authenticate users with a username and password when they visit our app. We could easily just store that information directly in the backend and then use a GET request when a user logs in, but that wouldn't be secure or a very good practice in general. Instead, we POST login requests and use tools like bcrypt and JWT to store and compare user data. In this series of posts, we'll go through how to set up your Rails API to have secure password storage, persisting user login with tokens, and user authorization for protected resources.

## Setting up the Rails API with bcrypt

To get started, we'll need to set up an API with `rails new --api your-api-name`. We are also going to turn on some additional Rails functionality with gems. The first gem we need to enable or install to securely store login information is the **bcrypt gem**.

![bcrypt preinstalled in gemfile](bcrypt-gem.png)

It should already be in your gemfile, and you can just uncomment it and run `bundle install` in your terminal. Bcrypt enables some secure hashing functionality in Rails which we will use to store a secure substitute for the user's password. [Cryptographic hashing](https://en.wikipedia.org/wiki/Cryptographic_hash_function) is an algorithmic, one-way transformation of information, resulting in a unique, fixed-length number[^1]. 

The TL;DR is that bcrypt takes the password string input, adds a little extra bit of information called "salt," chops everything up and mixes it around (like **hash** browns...), and then spits out a very random string of numbers (usually not base-10) which includes some information that lets bcrypt compare the hash with a later input. There is no way to figure out the initial input based on the hash result, which is why we can store the hash in our database without worrying about a hacker getting their hands on it. Good thing bcrypt takes care of hashing behind the scenes so we don't have to come up with our own hash function, huh?

## Generating a User with a secure password

With Rails and the bcrypt gem, it's very simple to create a user and store their password as a hash. First, we'll generate a user model, using `rails g model user username password` to create a model and database migration. Next we update both files: in the users database migration, change `:password` to `:password_digest`; in the User model, add the line `has_secure_password` at the top of the class.

![Updated users migration](updated-users-migration.png) ![Updated user model](updated-user-model.png)

These two things tell our Rails database "Hey, don't use the password the user sent us! Hash it with bcrypt first!" Now, when we send a request to either create a new user or log an existing user in, Rails will know to hash the password before storing it or trying to compare it to a saved hash. If you looked at a "password" after it was saved to the database, you would just see the random string the hash function generated.

## Up Next

That's it! We've now created a secure way of storing passwords in a Rails backend using bcrypt. In part two we'll use the secure password we've just created to log a user in and use JWT, tokens, and local storage to make sure they're logged in and authorized before performing other actions.


[^1]: In extremely rare cases, a hash function can return the same number result for two different inputs. This is called a "hash collision," and one of the primary considerations for a hashing function is how easily there might be a collision.
