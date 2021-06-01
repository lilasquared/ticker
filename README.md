# Portfolio Ticker

A simple ruby program to pull ticker information from yahoo finance api and display portfolio positions.

# How To

## Setup (mac/linux)

```bash
git clone https://github.com/lilasquared/ticker.git
cd ticker
bin/setup
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
ticker add GME -u 100 -c 100.00
ticker remove GME
```

## Monitoring

To monitor your portfolio use the `monitor` command

```sh
ticker monitor
```

you can also specify a custom interval (default is 5 seconds)

```sh
ticker monitor -i 10
```

or you can print it just once with

```sh
ticker print
```

## Why?

If you have holdings across many different platforms / accounts this can be used to show a nice consolidated view
