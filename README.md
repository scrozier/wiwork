# Wiwork

*wiwork* is a robust Ruby wrapper around the WhenIWork API. Key facts and features:

* every WhenIWork API endpoint supported (coming soon)
* for all objects, associated records are directly supported, using ActiveRecord like association methods (user.locations, e.g.)
* lazy loading of associations combines ease of use with performance
* extended associations are made available for ease of use; for example, although availabilities are not returned by the retrieval of a user from the API, *wiwork* makes availabilities available via a simple method on a user (User#availabilities)

## Installation

Add this line to your application's Gemfile:

    gem 'wiwork'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wiwork

## Usage

### Authentication

* You must first obtain a token for the WhenIWork API. Follow the instructions at <http://dev.wheniwork.com/#authentication>.

* Armed with your token, you can establish a *wiwork* connection. A *wiwork* connection caches objects retrieved from the API. Consequently, if you want to break the cache and re-retrieve objects from the API, you can establish a new session.

	when_i_work = WhenIWork::Connection.new('ilovemyboss')

Substitute in your own token for 'ilovemyboss', above.

### Accessing API endpoints via *wiwork*

Having established a connection, access WhenIWork API endpoints via methods on the connection that generally match the name of the API objects (users, locations, etc.). Plural object names (users, e.g.) are arrays of the underlying object. The underlying objects are POR (Plain Old Ruby) objects. You can access their attributes via reader methods. For example, you can use Location#name.

Some notes on method names:

* I have generally mimicked the WhenIWork API endpoint names, with a few exceptions:
  * "Listing _______" becomes just _______ (the object, like *locations* or *swaps*)
  * The word "existing" is eliminated, so the API's "Get Existing Location" becomes get_location

The methods:

* users
	* user.locations
	* user.positions
	* user.availabilities (extended association)

* Positions

#### Locations

  * locations -> array of WhenIWork::Location objects
  * get_location(id) -> WhenIWork::Location
  * create_location(hash_of_attributes) -> WhenIWork::Location
  * update_location(hash_of_attributes) -> WhenIWork::Location
  * delete_location(id) -> boolean

##### Latitude and longitude

When one adds a location directly through the WhenIWork web application, latitude and longitude coordinates are discovered and added to the Location record. When one adds a location via the API, coordinates are not discovered and added to the Location record. One can set those coordinates oneself, in a create_location or update_location call.

When specifying latitude and longitude in a create_location or update_location call, they should be specified as an Array of two Floats. I.e., [latitude, longitude]. For example, [32.829001, -96.748154]. Note that it appears that the coordinates must match Google Maps' latitude and longitude for the address exactly, or they (the coordinates) will not be stored.

##### Eager loading

Note than any use of any of the locations methods will result in *wiwork* eager loading all the locations from the API. Subsequent calls to any of the read-only locations methods (locations, get_location) will be handled out of *wiwork*'s cache created on the first hit.

### Logging

[Some general info about logging here.]

## Notes

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wiwork/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
