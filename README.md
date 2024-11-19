# CountMinSketch

An Elixir implementation of the Count-Min Sketch probabilistic data structure used for approximate counting of events in a stream.

The algorithm is based on the paper: [An Improved Data Stream Summary: The Count-Min Sketch and its Applications](http://dimacs.rutgers.edu/~graham/pubs/papers/cm-full.pdf) by Graham Cormode and S. Muthukrishnan, though a simpler follow-up paper by the same authors can be found in [Approximating Data with the Count-Min Data Structure](http://dimacs.rutgers.edu/~graham/pubs/papers/cmsoft.pdf)

## Installation

The package can be installed
by adding `count_min_sketch` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:count_min_sketch, "~> 0.1.0"}
  ]
end
```

## Error rate calculation

CountMinSketch is simple to use, though an important factor to take into account is the calculation of the expected error rate with a certain probability. An excerpt from [2] states:

> As a result, for a sketch of size w × d with total count N , it follows that any estimate has error at most 2N/w, with probability at least 1 − (1/2)^d. So setting the parameters w and d large enough allows us
to achieve very high accuracy while using relatively little space.

> For example:
Suppose we want an error of at most 0.1% (of the sum of all frequencies), with 99.9% certainty. Then
we want 2/w = 1/1000, we set w = 2000, and (1/2)^d = 0.001, i.e. d = log 0.001/ log 0.5 ≤ 10.

### Usage

```elixir
  # Creates a new CountMinSketch with 100 rows and 1000 columns 
  count_min_sketch = CountMinSketch.new(100, 1000)

  # Adds a new element to the sketch
  count_min_sketch = CountMinSketch.add(count_min_sketch, "foo")
    >CountMinSketch.add("foo")
    >CountMinSketch.add("foo")
    >CountMinSketch.add("foo")
    >CountMinSketch.add("foo")
    >CountMinSketch.add("foo")
    >CountMinSketch.add("bar")

  CountMinSketch.get_count(count_min_sketch, "foo")
  > 5
```elixir
