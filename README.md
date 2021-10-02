# petscii
Translate between PETSCII and ASCII

## Motivation
[PETSCII](https://en.wikipedia.org/wiki/PETSCII) (PET Standard Code of
Information Interchange), also known as CBM ASCII, is the character set
used in Commodore Business Machines (CBM)'s 8-bit home computers,
starting with the PET from 1977 and including the C16, C64, C116, C128,
CBM-II, Plus/4, and VIC-20.

This library offers some support functions for translating between
PETSCII and ASCII.

## Background
PETSCII has two different encodings (`shifted` and `unshifted`).

The `shifted` encoding includes both lowercase and uppercase letters
and a small selection of block graphics. This was also called "text mode".

The `unshifted` encoding includes only uppercase letters but features
a larger selection of block graphic characters and symbols, including
things like symbols for card suits.

## Example
The following example shows how `petscii` could be used in a project:

    var PETSCII, decode, encode;

    ({PETSCII} = require("petscii"));

    ({decode, encode} = PETSCII);

    // "♠♥♣♦"
    decode("unshifted", Buffer.from([0x61, 0x73, 0x78, 0x7a]));

    // "ASXZ"
    decode("shifted", Buffer.from([0x61, 0x73, 0x78, 0x7a]));

    // Buffer.from([0x68, 0x45, 0x4c, 0x4c, 0x4f, 0x2c, 0x20, 0x57, 0x4f, 0x52, 0x4c, 0x44, 0x21])
    encode("shifted", "Hello, world!");

## API
The `petscii` module provides two functions `decode` and `encode` to
translate between PETSCII and ASCII.

### decode(mode, buffer) -> String
Translate a Buffer with PETSCII data to an ASCII String:
* `mode` - One of `'shifted'` or `'unshifted'`
* `buffer` - A `Buffer` object with data to be decoded

`decode` will return a UTF-8 encoded String

This function enforces types and may throw a TypeError if incorrect
inputs are provided.

### encode(mode, string) -> Buffer
Translate an ASCII String to a Buffer with PETSCII data:
* `mode` - One of `'shifted'` or `'unshifted'`
* `string` - A String containing data to be encoded

`encode` will return a Buffer with PETSCII encoded data

This function enforces types and may throw a TypeError if incorrect
inputs are provided.

#### Unknown Characters
PETSCII does not include an encoding for all ASCII characters. For
example, curly braces like `{` and `}` do not exist in PETSCII. Thus,
there is no PETSCII code to represent them.

In the case of attempting to encode unknown characters, `encode` will
replace them with a code of `0x3f` (`?`) letting a question mark stand
in as the character that could not be represented in PETSCII.

Note that one must be careful which `mode` one is using to `encode`.
An ASCII string like `Hello, world!` can be encoded accurately in
`shifted` mode. However, in `unshifted` mode, it will contain several
question marks due to the lowercase letters that cannot be encoded.

    // Buffer.from([0x48, 0x3f, 0x3f, 0x3f, 0x3f, 0x2c, 0x20, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x21])
    encode("unshifted", "Hello, world!");

    // H????, ?????!
    decode("unshifted", Buffer.from([0x48, 0x3f, 0x3f, 0x3f, 0x3f, 0x2c, 0x20, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x21]));

## Development
In order to make modifications to petscii, you'll need to establish a
development environment:

    git clone https://github.com/blinkdog/petscii.git
    cd petscii
    npm install
    node_modules/.bin/cake rebuild

The source files are located in `src/main/coffee`.  
The test source files are located in `src/test/coffee`.

You can see a coverage report by invoking the `coverage` target:

    node_modules/.bin/cake coverage

## License
petscii  
Copyright 2021 Patrick Meade.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
