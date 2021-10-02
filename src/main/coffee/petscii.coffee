# petscii.coffee
# Copyright 2021 Patrick Meade.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#----------------------------------------------------------------------------

{fn} = require "floweret"

Mode = ['shifted', 'unshifted']

ASCII_TABLE = {}

PETSCII_TABLE =
    shifted: [
        '\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07', '\x08', '\x09', '\x0a', '\x0b', '\x0c', '\x0d', '\x0e', '\x0f',
        '\x10', '\x11', '\x12', '\x13', '\x14', '\x15', '\x16', '\x17', '\x18', '\x19', '\x1a', '\x1b', '\x1c', '\x1d', '\x1e', '\x1f',
           ' ',    '!',    '"',    '#',    '$',    '%',    '&',    "'",    '(',    ')',    '*',    '+',    ',',    '-',    '.',    '/',
           '0',    '1',    '2',    '3',    '4',    '5',    '6',    '7',    '8',    '9',    ':',    ';',    '<',    '=',    '>',    '?',
           '@',    'a',    'b',    'c',    'd',    'e',    'f',    'g',    'h',    'i',    'j',    'k',    'l',    'm',    'n',    'o',
           'p',    'q',    'r',    's',    't',    'u',    'v',    'w',    'x',    'y',    'z',    '[',    '£',    ']',    '↑',    '←',
           '🭹',    'A',    'B',    'C',    'D',    'E',    'F',    'G',    'H',    'I',    'J',    'K',    'L',    'M',    'N',    'O',
           'P',    'Q',    'R',    'S',    'T',    'U',    'V',    'W',    'X',    'Y',    'Z',    '┼',    '🮌',    '│',    '🮖',    '🮘',
        '\x80', '\x81', '\x82', '\x83', '\x84', '\x85', '\x86', '\x87', '\x88', '\x89', '\x8a', '\x8b', '\x8c', '\x8d', '\x8e', '\x8f',
        '\x90', '\x91', '\x92', '\x93', '\x94', '\x95', '\x96', '\x97', '\x98', '\x99', '\x9a', '\x9b', '\x9c', '\x9d', '\x9e', '\x9f',
        '\xa0',    '▌',    '▄',    '▔',    '▁',    '▏',    '▒',    '▕',    '🮏',    '🮙',    '🮇',    '├',    '▗',    '└',    '┐',    '▂',
           '┌',    '┴',    '┬',    '┤',    '▎',    '▍',    '🮈',    '🮂',    '🮃',    '▃',    '✓',    '▖',    '▝',    '┘',    '▘',    '▚',
           '🭹',    'A',    'B',    'C',    'D',    'E',    'F',    'G',    'H',    'I',    'J',    'K',    'L',    'M',    'N',    'O',
           'P',    'Q',    'R',    'S',    'T',    'U',    'V',    'W',    'X',    'Y',    'Z',    '┼',    '🮌',    '│',    '🮖',    '🮘',
        '\xa0',    '▌',    '▄',    '▔',    '▁',    '▏',    '▒',    '▕',    '🮏',    '🮙',    '🮇',    '├',    '▗',    '└',    '┐',    '▂',
           '┌',    '┴',    '┬',    '┤',    '▎',    '▍',    '🮈',    '🮂',    '🮃',    '▃',    '✓',    '▖',    '▝',    '┘',    '▘',    '🮖',
    ]
    unshifted: [
        '\x00', '\x01', '\x02', '\x03', '\x04', '\x05', '\x06', '\x07', '\x08', '\x09', '\x0a', '\x0b', '\x0c', '\x0d', '\x0e', '\x0f',
        '\x10', '\x11', '\x12', '\x13', '\x14', '\x15', '\x16', '\x17', '\x18', '\x19', '\x1a', '\x1b', '\x1c', '\x1d', '\x1e', '\x1f',
           ' ',    '!',    '"',    '#',    '$',    '%',    '&',    "'",    '(',    ')',    '*',    '+',    ',',    '-',    '.',    '/',
           '0',    '1',    '2',    '3',    '4',    '5',    '6',    '7',    '8',    '9',    ':',    ';',    '<',    '=',    '>',    '?',
           '@',    'A',    'B',    'C',    'D',    'E',    'F',    'G',    'H',    'I',    'J',    'K',    'L',    'M',    'N',    'O',
           'P',    'Q',    'R',    'S',    'T',    'U',    'V',    'W',    'X',    'Y',    'Z',    '[',    '£',    ']',    '↑',    '←',
           '🭹',    '♠',    '🭲',    '🭸',    '🭷',    '🭶',    '🭺',    '🭱',    '🭴',    '╮',    '╰',    '╯',    '🭼',    '╲',    '╱',    '🭽',
           '🭾',    '●',    '🭻',    '♥',    '🭰',    '╭',    '╳',    '○',    '♣',    '🭵',    '♦',    '┼',    '🮌',    '│',    'π',    '◥',
        '\x80', '\x81', '\x82', '\x83', '\x84', '\x85', '\x86', '\x87', '\x88', '\x89', '\x8a', '\x8b', '\x8c', '\x8d', '\x8e', '\x8f',
        '\x90', '\x91', '\x92', '\x93', '\x94', '\x95', '\x96', '\x97', '\x98', '\x99', '\x9a', '\x9b', '\x9c', '\x9d', '\x9e', '\x9f',
        '\xa0',    '▌',    '▄',    '▔',    '▁',    '▏',    '▒',    '▕',    '🮏',    '◤',    '🮇',    '├',    '▗',    '└',    '┐',    '▂',
           '┌',    '┴',    '┬',    '┤',    '▎',    '▍',    '🮈',    '🮂',    '🮃',    '▃',    '🭿',    '▖',    '▝',    '┘',    '▘',    '▚',
           '🭹',    '♠',    '🭲',    '🭸',    '🭷',    '🭶',    '🭺',    '🭱',    '🭴',    '╮',    '╰',    '╯',    '🭼',    '╲',    '╱',    '🭽',
           '🭾',    '●',    '🭻',    '♥',    '🭰',    '╭',    '╳',    '○',    '♣',    '🭵',    '♦',    '┼',    '🮌',    '│',    'π',    '◥',
        '\xa0',    '▌',    '▄',    '▔',    '▁',    '▏',    '▒',    '▕',    '🮏',    '◤',    '🮇',    '├',    '▗',    '└',    '┐',    '▂',
           '┌',    '┴',    '┬',    '┤',    '▎',    '▍',    '🮈',    '🮂',    '🮃',    '▃',    '🭿',    '▖',    '▝',    '┘',    '▘',    'π',
    ]

QUESTION_MARK = 0x3F

decode = fn Mode, Buffer, String,
    (mode, buf) ->
        retVal = ""
        for byte in buf
            retVal += PETSCII_TABLE[mode][byte]
        return retVal

encode = fn Mode, String, Buffer,
    (mode, str) ->
        buf = []
        for char in str
            buf.push ASCII_TABLE[mode][char] || QUESTION_MARK
        return Buffer.from buf

exports.PETSCII =
    MODE: Mode
    TABLE: PETSCII_TABLE
    decode: decode
    encode: encode

do ->
    for mode in Mode
        ASCII_TABLE[mode] = {}
        for i in [255..0]
            char = PETSCII_TABLE[mode][i]
            ASCII_TABLE[mode][char] = i

#----------------------------------------------------------------------------
# end of petscii.coffee
