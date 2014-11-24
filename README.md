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

* You must first obtain a token for the WhenIWork API. Follow the instructions at <http://dev.wheniwork.com/#authentication>.

* Armed with your token, you can establish a *wiwork* connection. A *wiwork* connection caches objects retrieved from the API. Consequently, if you want to break the cache and re-retrieve objects from the API, you can establish a new session.

	when_i_work = WhenIWork::Connection.new(TOKEN)

Having established a connection, access WhenIWork API endpoints via methods on the connection that generally match the name of the API objects (users, locations, etc.). Plural object names (users, e.g.) are arrays of the underlying object. The underlying objects are POR (Plain Old Ruby) objects.

The methods are listed here:

* users
	* user.locations
	* user.positions
	* user.availabilities (extended association)

## Notes

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wiwork/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
