defmodule Wrapper2Test do
  use ExUnit.Case
  doctest Wrapper2

  test "empty string gives an empty string" do
    assert Wrapper2.wrap("", 1) == ""
  end

  test "one char and line length of 1 gives the char back" do
    assert Wrapper2.wrap("x", 1) == "x"
  end

  test "word larger than line length is split" do
    assert Wrapper2.wrap("xy", 1) == "x\ny"
  end

  test "word three time longer than line length is split 3 times" do
    assert Wrapper2.wrap("xyz", 1) == "x\ny\nz"
  end

  test "two words are split" do
    assert Wrapper2.wrap("x y", 1) == "x\ny"
  end

  test "two words are split max length 2" do
    assert Wrapper2.wrap("x y", 2) == "x\ny"
  end

  @tag :wip
  test "three words" do
    assert Wrapper2.wrap("uv wx yz ", 5) == "uv wx\nyz"
  end
end
