defmodule Wrapper2 do
  @moduledoc """
  Documentation for Wrapper.
  """

  @doc """
  Given a string of words separated by single spaces, and given a desired line length, insert line-end
  characters into the string at appropriate points to ensure that no line is longer than the length.
  Words may be broken apart only if they are longer than the specified length.

  ##Example
      iex> Wrapper2.wrap("However, in many circumstances, we want to check", 10)
      "However,
      in many
      circumstan
      ces, we
      want to
      check"
  """
  def wrap(line, max_line_length) when is_binary(line) do
    line
    |> split_into_blocks()
    |> split_long_blocks(max_line_length)
    |> join_blocks_into_lines(max_line_length)
  end

  defp split_into_blocks(line) do
    line
    |> String.split()
    |> add_size_of_blocks()
  end

  defp add_size_of_blocks(blocks) do
    blocks
    |> Enum.map(&String.length/1)
    |> Enum.zip(blocks)
  end

  defp split_long_blocks(blocks, max_block_size) do
    blocks
    |> Enum.map(fn {s, b} = x ->
      if s > max_block_size do
        split_block_every(b, max_block_size)
      else
        x
      end
    end)
    |> List.flatten()
  end

  defp split_block_every(block, nth) do
    block
    |> String.codepoints()
    |> Enum.chunk_every(nth)
    |> Enum.map(&Enum.join/1)
    |> add_size_of_blocks()
  end

  defp join_blocks_into_lines(blocks, nth) do
    blocks
    |> Enum.reduce({0, []}, fn {size, _} = block, {remaining, _} = acc ->
      if size <= remaining do
        append_block_to_current_block(block, acc)
      else
        add_block_to_new_line(block, acc, nth)
      end
    end)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp append_block_to_current_block({size, block}, {remaining, [line | tail]}) do
    {remaining - size, [Enum.join([line, block], " ") | tail]}
  end

  defp add_block_to_new_line({size, block}, {_remaining, lines}, nth) do
    {nth - size - 1, [block | lines]}
  end
end
