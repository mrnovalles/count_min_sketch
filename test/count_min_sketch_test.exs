defmodule CountMinSketchTest do
  use ExUnit.Case

  describe "new/2" do
    test "creates CountMinSketch with desired width and depth" do
      for {i, j} <- [{1,1}, {2,2}, {10, 10}] do
        cms = CountMinSketch.new(i, j)
        assert cms.width == i
        assert cms.depth == j
        assert length(cms.indexed_table) == i
        assert Enum.all?(cms.indexed_table, fn {_, array} -> :array.size(array) == j end)
      end
    end
  end

  describe "add/2" do
    test "sets the value of the [`d`, `w`] cell of the table" do
      cms = CountMinSketch.new(5, 5)
      %{indexed_table: indexed_table} = CountMinSketch.add(cms, "hello")
      Enum.all?(indexed_table, fn {_, array} -> 
        :array.sparse_to_list(array) == [1, 1, 1, 1, 1]
      end)
    end

    test "sets the value of the [`d`, `w`] cell of the table with collisions" do
      %{indexed_table: indexed_table} =
        CountMinSketch.new(1, 1)
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("bar")

      # The low cardinality of the table will cause collisions and all the items endup in the same cell
      Enum.each(indexed_table, fn {_, array} ->
       assert :array.sparse_to_list(array) == [4]
      end)
    end

    test "sets the value of the [`d`, `w`] cell of the table with reduced collisions" do
      %{indexed_table: indexed_table} =
        CountMinSketch.new(100, 1000)
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("bar")

      # The low cardinality of the table will cause collisions and all the items endup in the same cell
      Enum.each(indexed_table, fn {_, array} ->
       assert array
          |> :array.sparse_to_list()
          |> Enum.sort() == [1,2,3]
      end)
    end
  end

  describe "get_count/2" do
    test "returns the correct count" do
        cms = CountMinSketch.new(100, 1000)
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("bar")

      assert 0 == CountMinSketch.get_count(cms, "foo")
      assert 1 == CountMinSketch.get_count(cms, "bar")
      assert 2 == CountMinSketch.get_count(cms, "hello")
      assert 3 == CountMinSketch.get_count(cms, "world")
    end

    test "returns an incorrect count when collisions ocurr" do
        cms = CountMinSketch.new(2, 2)
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("world")
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("hello")
        |> CountMinSketch.add("bar")

      assert 1 == CountMinSketch.get_count(cms, "bar")
      # CountMinSketch can overestimate but never underestimate
      assert 5 == CountMinSketch.get_count(cms, "hello")
      assert 5 == CountMinSketch.get_count(cms, "world")
    end
  end
end
