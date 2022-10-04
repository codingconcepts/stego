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

```
$ stego

Usage:
    stego [command] [arguments]

  Commands:
    conceal -i inconspicuous.png [files]  Conceal files or a directory in an image, or leave blank to conceal text.
    help [command]                        Help about any command.
    reveal -i inconspicuous.png           Reveal files or a message.

  Flags:
    -h, --help  Help for this command.
```

#### Conceal text

```
$ stego conceal text \
    -i testing/input.png \
    -o testing/output.png

Enter text to conceal:
Attack at dawn! Or whenever convenient.
```

#### Reveal text

```
$ stego reveal text \
    -i testing/output.png

Attack at dawn! Or whenever convenient.
```

#### Conceal files

```
$ stego conceal file \
    -i testing/input.png \
    -o testing/output.png \
    testing/a.csv testing/b.csv

Concealing file:
  - testing/a.csv
  - testing/b.csv
```

Can also be used with custom glob patterns:

```
$ stego conceal file \
    -i testing/input.png \
    -o testing/output.png \
    -g "**/*.csv"
    testing/a.csv testing/b.csv

Concealing file:
  - testing/a.csv
  - testing/b.csv
```

#### Reveal files

```
$ stego reveal file \
    -i testing/output.png

  - a.csv
  - b.csv
```

#### Get image stats

```
$ stego stat \
    -i testing/input.png

Dimensions  = 256x256
Can conceal = 24.0kiB
```

# Todos

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