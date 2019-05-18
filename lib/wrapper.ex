defmodule Wrapper do
  @moduledoc """
  Documentation for Wrapper.
  """

  @doc """
  Given a string of words separated by single spaces, and given a desired line length, insert line-end
  characters into the string at appropriate points to ensure that no line is longer than the length.
  Words may be broken apart only if they are longer than the specified length.

  ##Example
      iex> Wrapper.wrap("However, in many circumstances, we want to check", 10)
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
    |> Enum.map(&split_block_every(&1, max_block_size))
    |> List.flatten()
  end

  defp split_block_every({size, _word} = block, nth) when size <= nth do
    block
  end

  defp split_block_every({_size, word}, nth) do
    word
    |> String.codepoints()
    |> Enum.chunk_every(nth)
    |> Enum.map(&Enum.join/1)
    |> add_size_of_blocks()
  end

  defp join_blocks_into_lines(blocks, nth) do
    blocks
    |> Enum.reduce({0, [], nth}, &assemble_block/2)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp assemble_block({size, word}, {remaining, [line | tail], nth}) when size <= remaining do
    {remaining - size, [line <> " " <> word | tail], nth}
  end

  defp assemble_block({size, word}, {_remaining, lines, nth}) do
    {nth - size - 1, [word | lines], nth}
  end
end
