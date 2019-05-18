defmodule Wrapper do
  @moduledoc """
  Text Module
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
    assemble(line, max_line_length)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp assemble(line, max_line_length) do
    line
    |> String.split()
    |> size_of_each_word()
    |> split_line_into_multiple_lines(max_line_length)
  end

  defp size_of_each_word(word_list) do
    Enum.map(word_list, fn x ->  {x, String.length(x)} end)
  end

  defp split_line_into_multiple_lines(line, max_line_length) do
    Enum.reduce(line, {[], 0}, fn {word, word_length} = w, {lines, remaining_length} = l ->
      cond do
        word_length > max_line_length ->
          split_and_append_long_word(word, lines, max_line_length)
        word_length <= remaining_length ->
          append_word_to_current_line(w, l)
        true ->
          add_word_to_new_line(w, lines, max_line_length)
      end
    end)
  end

  defp split_and_append_long_word(word, lines, max_line_length) do
    {new_lines, remaining_line_length} = split_word(word, max_line_length)
    {new_lines ++ lines, remaining_line_length}
  end

  defp append_word_to_current_line({word, word_length}, {[line | tail], remaining_line_length}) do
    {[line <> " " <> word| tail], remaining_line_length - word_length}
  end

  defp add_word_to_new_line({word, word_length}, lines, max_line_length) do
    {[word | lines], max_line_length - word_length - 1}
  end

  defp split_word(word, max_line_length) do
    word
    |> slice_word_into_multiple_lines(max_line_length)
    |> assemble(max_line_length)
  end

  defp slice_word_into_multiple_lines(word, max_line_length) do
    word
    |> String.codepoints
    |> Enum.chunk_every(max_line_length)
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end
end
