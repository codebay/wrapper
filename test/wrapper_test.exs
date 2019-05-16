defmodule WrapperTest do
  use ExUnit.Case
  doctest Wrapper

  test "empty string gives an empty string" do
    assert Wrapper.wrap("", 1) == ""
  end

  test "one char and line length of 1 gives the char back" do
    assert Wrapper.wrap("x", 1) == "x"
  end

  test "word larger than line length is split" do
    assert Wrapper.wrap("xy", 1) == "x\ny"
  end

  test "word three time longer than line length is split 3 times" do
    assert Wrapper.wrap("xyz", 1) == "x\ny\nz"
  end

  test "two words are split" do
    assert Wrapper.wrap("x y", 1) == "x\ny"
  end

  test "two words are split max length 2" do
    assert Wrapper.wrap("x y", 2) == "x\ny"
  end

end
