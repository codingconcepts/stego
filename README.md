```
 ████  █████ ██████  ████   ████  
▓        ▓   ▓      ▓    ▓ ▓    ▓ 
 ▒▒▒▒    ▒   ▒▒▒▒▒  ▒      ▒    ▒ 
     ▒   ▒   ▒      ▒  ▒▒▒ ▒    ▒ 
 ░░░░    ░   ░░░░░░  ░░░░   ░░░░ 

Hide your stuff in PNGs.
```

# Installation

Install Stego using the latest binary from the [Releases](https://github.com/codingconcepts/stego/releases/latest) page and extracting the binary from the tar file as follows:

```
$ tar -xzf build/stego_[VERSION]_macos.tar.gz
```

# Usage

## Interactive mode

To use Stego in interactive mode, simply open the binary without any arguments:

To conceal text:

```
$ stego

Conceal or Reveal (c)/r

Enter text to conceal:
> Attack at dawn

Enter path to PNG carrier image input:
> input.png

Enter path to PNG carrier image ouput (or leave empty to overwrite input):
> output.png
```

To reveal text:

```
$ stego

Conceal or Reveal (c)/r

Enter path to PNG carrier image ouput:
> output.png

Attack at dawn
```

## File mode (conceal)

To use Stego to conceal files, invoke the binary with to the paths to 2 or more input files. One (and only one) should be a PNG file to be used as a carrier image, while the other files can be of any type.

In the following example, we hide a.csv and b.csv into input.png:

```
$ stego testing/ testing/input.png

Concealing ["testing/a.csv", "testing/b.csv"] in testing/input.png

Enter path to PNG carrier image ouput (or leave empty to overwrite input):
testing/output.png
```

## File mode (reveal)

To use Stego to reveal files, invoke the binary with the path to one PNG carrier image.

In the following example, we extract a.csv and b.csv from the carrier image and write them into a new zip file called stego.zip:

```
$ stego testing/output.png

Revealing testing/output.png into stego.zip
  - a.csv
  - b.csv
```

# Todos

* Better CLI experience using commands, for example:

```
$ stego -h
  conceal   Conceal a message or files
  reveal    Reveal a message or files
  stats     Get image stats

$ stego conceal -h
  -m        The message to conceal
  -i        The absolute or relative path to the image to conceal data in

$ stego reveal -h
  -i        The absolute or relative path to the image to reveal data from

$ stego stats -h
  -i        The absolute or relative path to the image to generate stats for
```

* Header section

Create a binary-encoded header section like the following example:

| Section        | Example                           |
| -------        | -------                           |
| Message length | 000000000000000000000001001000011 |
| Colour from    | 000000
|                | 0000 0000 0000 0000 0000 0000     |
| Colour to      | ffffff                            |
|                | 1111 1111 1111 1111 1111 1111     |

Giving and 80 bit header similar to:

```
000000000000000000000001001000011000000000000000000000000111111111111111111111111
```

* Message encryption

* Header encryption