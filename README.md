# Kata - Word wrapping

From Robert Martin and his blog, which includes a solution in Java [1](http://thecleancoder.blogspot.com/2010/10/craftsman-62-dark-path.html)

## Description

You write a class called Wrapper, that has a single static function named wrap that takes two arguments, a string, and a column number. The function returns the string, but with line breaks inserted at just the right places to make sure that no line is longer than the column number. You try to break lines at word boundaries.

Like a word processor, break the line by replacing the last space in a line with a newline.

Given a line of text

  "The cat sat on the mat, on a mountainous and the mat slide down the hill”

That we want to warp at 8 characters

Start with “The” it has three characters and so will fit into an eight character line

```
  “The     “
```

leaving four characters for the next word, since we will need one character after “The” to space the words.

The next word is “cat” this is again 3 characters and so we can add it into remain 4 characters of the line without breaking up the word.

```
  “The cat “
```

The are no characters left now because we cannot put even a single character after “cat” without exceeding the maximum line length. So a new line is created.

```
  “The cat\n        “
```

The escaped character “\n” marks the end of the a line.

The next word is “sat” and another 3 letter word can again we can add this the line leaving 4 characters available.

```
  “The cat\nsat     “
```

And so on…

```
  “The cat\nsat on\nthe mat,\non a\n        “
```

Until we get to the word “mountainous” which is 11 characters. The only way we can fit this word is to break it up into blocks of 8.

```
  “The cat\nsat on\nthe mat,\non a\nmountian\nous     “
```

The next word is “the” which at 3 characters will fit on the current line

```
  “The cat\nsat on\nthe mat,\non a\nmountian\nous the\n“
```

And so the process continuous.


## Algorithm in Elixir

This kata is often solved using a recursive solution as in Robert Martin's solution, and a blog by [Code-Cop](http://blog.code-cop.org/2011/08/word-wrap-kata-variants.html). The solution here does not require a recursive solution.

Initial line represented by a string, and we can consider each word with any punctuation as a block

```
  “<block> <block> <block> ….. <block>”
```

Split line into a LIST of blocks

```
  [“<block>”, “<block>”, …, “<block>”]
```

Determine size of each block and represent by a list of tuples

```
  [{“<block>”, block size}, {“<block>”, block size}, ….
```

Split any tuple that has a block size > max line length into a LIST of tuple blocks of not greater than max line length

```
  {large block, size} => [{block, max length}, …, {block, size}]
```

Replace tuple in original block list with new list of tuples

Each new line can be represented by a List of lines made up of blocks

```
  [“<block> <block>”, “<block>”, “<block> <block>”, …]
```

Finally join the lines together with “\n”
