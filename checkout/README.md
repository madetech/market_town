# Market Town: Checkout

Checkout business logic for your ruby e-commerce. This gem is framework
independent but provides integration with Spree and Webhooks.

You can introduce MarketTown::Checkout as an interface between your application
and your e-commerce backend. Using the power of dependency injection you can
provide implementation specific logic for applying promotions, saving addresses,
taking payments, etc. in your e-commerce store.

If you've ever wanted to gradually replace Spree with your own system, or split
Spree out into a number of different services then you're in the right place.

## Mission

 - Handle common use cases of checkout step behaviour
 - Provide a Spree dependency container for writing your own checkout
   controllers that speak to Spree objects underneath
 - Provide a Webhook dependency container that will forward calls onto a HTTPS
   interface of your choice

## Getting started

 - [Introduction](https://github.com/madetech/market_town/blob/master/checkout/INTRODUCTION.md)
 - [API documentation](http://madetech.github.io/market_town/checkout/)
 - [Read the code](https://github.com/madetech/market_town/tree/master/checkout/)

## Contributing

 - Follow the [Code of Conduct](https://github.com/madetech/market_town/blob/master/CODE_OF_CONDUCT.md)
 - Run tests with `bundle exec rake`

## Author

Luke Morton at Made Tech
