# Prueba técnica Mybooking



## Preparing the environment
```
bundle install
````

Create an .env file at project root with the following variables

```ruby
COOKIE_SECRET="THE-COOKIE-SECRET"
DATABASE_URL="mysql://user:password@host:port/prueba_tecnica?encoding=UTF-8-MB4"
TEST_DATABASE_URL="mysql://user:password@host:port/prueba_tecnica_test?encoding=UTF-8-MB4"
```

## Running the application

```
bundle exec rackup
```

Then, you can open the browser and check

http://localhost:9292
http://localhost:9292/api/sample



## Working with Rake for command line utils

A basic task, foo:bar, has been implemented to show how it works

```
bundle exec rake foo:bar
```