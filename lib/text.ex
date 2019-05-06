defmodule Text do
  @moduledoc """
  Text Module
  """

  @doc """
  Given a string of words separated by single spaces, and given a desired line length, insert line-end
  characters into the string at appropriate points to ensure that no line is longer than the length.
  Words may be broken apart only if they are longer than the specified length.

  ##Example
      iex> Text.line_wrap("However, in many circumstances, we want to check", 10)
      "However,
      in many
      circumstan
      ces, we
      want to
      check"
  """
  def line_wrap(line, max_length) do
    line_wrap2(line, max_length)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp line_wrap2(line, max_length) do
    String.split(line)
    |> Enum.map(fn x ->  {x, String.length(x)} end)
    |> Enum.reduce({[], 0}, fn {word, length} = w, {lines, remaining_length} = l ->
      cond do
        length > max_length ->
          split_and_append_long_word(word, lines, max_length)
        length <= remaining_length ->
          append_word_to_current_line(w, l)
        true ->
          add_word_to_new_line(w, lines, max_length)
      end
    end)
  end

  defp split_and_append_long_word(word, lines, max_length) do
    {new_lines, remaining_length} = split_word(word, max_length)
    {new_lines ++ lines, remaining_length}
  end

  defp split_word(word, max_length) do
    word
    |> slice_word_into_blocks(max_length)
    |> line_wrap2(max_length)
  end

  defp slice_word_into_blocks(word, max_length) do
    word
    |> String.codepoints
    |> Enum.chunk_every(max_length)
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  defp add_word_to_new_line({word, length}, lines, max_length) do
    {[word | lines], max_length - length - 1}
  end

  defp append_word_to_current_line({word, length}, {[line | tail], remaining_length}) do
    {[Enum.join([line, word], " ") | tail], remaining_length - length}
  end

end
