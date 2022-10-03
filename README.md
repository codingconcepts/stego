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