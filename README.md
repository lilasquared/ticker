# Portfolio Ticker

A simple ruby program to pull ticker information from yahoo finance api and display portfolio positions.

## How To

Add a `ticker.yml` file using the format found in `ticker_example.yml`. Each symbol you provide will be used to fetch the `regularMarketPrice` from the yahoo-finance api. The given `shares` and `cost_basis` will be used to calculate your position value and change.

Note: `cost_basis` here should be the avg price paid per share

before running:

```sh
bundle install
```

to run:

```sh
ruby ticker.rb
```

to run in a loop: (defaults to 5 second intervals)

```sh
ruby ticker.rb loop
```

to run in a loop with a custom interval:

```sh
ruby ticker.rb loop=10
```

## Why?

If you have holdings across many different platforms / accounts this can be used to show a nice consolidated view
