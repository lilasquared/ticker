# Portfolio Ticker

A simple ruby program to pull ticker information from yahoo finance api and display portfolio positions.

# How To

## Setup

Make sure you have ruby installed.

```bash
git clone https://github.com/lilasquared/ticker.git
cd ticker
bundle
```

## Configuration

You can configure the ticker 2 ways.

1. Add a `ticker.yml` file using the format below. Each symbol you provide will be used to fetch the `regularMarketPrice` from the yahoo-finance api. The given `units` and `cost_basis` will be used to calculate your position value and change. Note: `cost_basis` here should be the avg price paid per share

```yml
# ticker.yml
GME:
  units: 100
  cost_basis: 100.00
```

2. Use ticker itself to add portfolio positions

```bash
ruby ticker.rb add GME -u 100 -c 100.00
ruby ticker.rb remove GME
```

## Monitoring

To monitor your portfolio use the `monitor` command

```sh
ruby ticker.rb monitor
```

you can also specify a custom interval (default is 5 seconds)

```sh
ruby ticker.rb monitor -i 10
```

## Why?

If you have holdings across many different platforms / accounts this can be used to show a nice consolidated view
