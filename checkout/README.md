# Market Town: Checkout

[![Build Status](https://travis-ci.org/madetech/market_town.svg?branch=master)](https://travis-ci.org/madetech/market_town)
[![Code Climate](https://codeclimate.com/github/madetech/market_town/badges/gpa.svg)](https://codeclimate.com/github/madetech/market_town)
[![Code Coverage](https://img.shields.io/codecov/c/github/madetech/market_town.svg)](https://codecov.io/gh/madetech/market_town)

Checkout logic for your online store. With Spree and webhook integrations.

MarketTown::Checkout is an interface for building checkouts that does not rely
on state machines and is easily customisable.

If you've ever wanted to gradually replace Spree with your own system, or split
Spree out into a number of different services then you're in the right place.

## Mission

 - Handle common use cases of checkout step behaviour including:
    - Cart
    - Address
    - Delivery
    - Payment
    - Complete
 - Provide a Spree integration for writing your own checkout controllers and
   flows that speak to Spree objects underneath
 - Provide a Webhook integration that will forward calls onto a HTTPS
   interface of your choice

## Getting started

 - [Introduction](https://github.com/madetech/market_town/blob/master/checkout/INTRODUCTION.md)
 - [API documentation](http://madetech.github.io/market_town/MarketTown/Checkout.html)
 - [Read the code](https://github.com/madetech/market_town/tree/master/checkout/)

## Contributing

 - Follow the [Code of Conduct](https://github.com/madetech/market_town/blob/master/CODE_OF_CONDUCT.md)
 - Run tests with `bundle exec rake`
 - Build coverage report with `COVERAGE=true bundle exec rake` then view in
   `coverage/` directory

## License

MIT

## Author

Luke Morton at [Made Tech](https://madetech.com)
