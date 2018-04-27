# Robinhood::Api
[![Gem Version](https://badge.fury.io/rb/robinhood-api.svg)](https://badge.fury.io/rb/robinhood-api) 
[![Build Status](https://travis-ci.org/ThomasMarcel/robinhood-api.svg?branch=master)](https://travis-ci.org/ThomasMarcel/robinhood-api) 
[![Coverage Status](https://coveralls.io/repos/github/ThomasMarcel/robinhood-api/badge.svg?branch=master)](https://coveralls.io/github/ThomasMarcel/robinhood-api?branch=master) 
[![Maintainability](https://api.codeclimate.com/v1/badges/8ecfb033edb5380098cf/maintainability)](https://codeclimate.com/github/ThomasMarcel/robinhood-api/maintainability) 
[![Test Coverage](https://api.codeclimate.com/v1/badges/8ecfb033edb5380098cf/test_coverage)](https://codeclimate.com/github/ThomasMarcel/robinhood-api/test_coverage) 
[![Dependency Status](https://beta.gemnasium.com/badges/github.com/ThomasMarcel/robinhood-api.svg)](https://beta.gemnasium.com/projects/github.com/ThomasMarcel/robinhood-api) 
[![Open Source Helpers](https://www.codetriage.com/cucumber/cucumber-rails/badges/users.svg)](https://www.codetriage.com/cucumber/cucumber-rails) 

__Get the most of Robinhood: accounts, positions, portfolio, buy and sell securities, etc.__  

[GitHub Repository](https://github.com/ThomasMarcel/robinhood-api)  
[rubygems.org page](https://rubygems.org/gems/robinhood-api)  

## Usage

1. Set the `ROBINHOOD_USERNAME` and `ROBINHOOD_PASSWORD` in your environment  
e.g. in your `~/.bash_profile` or `~/.bashrc` file:  
```sh
export ROBINHOOD_USERNAME="aaa"
export ROBINHOOD_PASSWORD="bbb"
```  
1. In you rb file:  
```ruby
robinhood = Robinhood::Api,new  

robinhood.login(
  ENV['ROBINHOOD_USERNAME'],
  ENV['ROBINHOOD_PASSWORD']
)

# Getting the list of orders made by the user
@orders = robinhood.orders
```

### Methods

#### General

* login  
* accounts  
* investment_profile  
* portfolio  

#### Orders

* orders  
* cancel_order  
* buy  
* limit_buy  
* sell  
* limit_sell  
* stop_loss_sell  

#### Quotes

* quote  

#### Positions and Instruments

* instruments  
* position  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'robinhood-api'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install robinhood-api
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
