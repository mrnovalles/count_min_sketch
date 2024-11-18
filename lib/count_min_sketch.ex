defmodule CountMinSketch do
  @moduledoc """
  Documentation for `CountMinSketch`.
  """

  @doc """
  An Elixir implementation of the Count-Min Sketch data structure.

  The Count-Min Sketch is a probabilistic data structure used to estimate the frequency of elements in a data stream.
  It becomes useful in scenarios where the more common approach of counting with a hash table is not feasible due to memory constraints.

  The creation of the CountMinSketch structure reuires the definition of `depth` and `width` parameters.
  - depth: The number of hash functions used to index the table. 
  The more hash functions we have the less likely for a collision to happen and the error on counts can be reduced.
   
  - width: The number of columns in the table used to store the counts. 

  Based on the paper "An Improved Data Stream Summary: The Count-Min Sketch and its Applications" by raham Cormode a, S. Muthukrishnan

  ## Examples

      iex> CountMinSketch.new(5, 5)
      %CountMinSketch{
        depth: 5,
        width: 5,
        indexed_table: [
          {0, {:array, 5, 0, 0, 10}},
          {1, {:array, 5, 0, 0, 10}},
          {2, {:array, 5, 0, 0, 10}},
          {3, {:array, 5, 0, 0, 10}},
          {4, {:array, 5, 0, 0, 10}}
        ]
      }

  """
  defstruct [:depth, :width, :indexed_table]

  @spec new(integer(), integer()) :: %__MODULE__{}
  def new(depth, width) do
    initial_array = :array.new(width, default: 0)

    %CountMinSketch{
      depth: depth,
      width: width,
      indexed_table: Enum.map(0..(depth - 1), &{&1, initial_array})
    }
  end

  @spec add(%__MODULE__{}, String.t()) :: %__MODULE__{}
  def add(%__MODULE__{indexed_table: indexed_table, width: width} = count_min_sketch, element) do
    indexed_table =
      indexed_table
      |> Enum.map(fn {row_index, array} ->
        column_index = hash(element, row_index, width)
        value = :array.get(column_index, array)
        {row_index, :array.set(column_index, value + 1, array)}
      end)

    %{count_min_sketch | indexed_table: indexed_table}
  end

  @spec get_count(%__MODULE__{}, String.t()) :: integer()
  def get_count(%__MODULE__{indexed_table: indexed_table, width: width}, element) do
    indexed_table
    |> Enum.map(fn {row_index, array} ->
      column_index = hash(element, row_index, width)
      :array.get(column_index, array)
    end)
    |> Enum.min()
  end

  defp hash(element, seed, width) do
    :erlang.phash2(element <> to_string(seed), width) |> rem(width)
  end
end
