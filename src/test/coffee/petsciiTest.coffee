# petsciiTest.coffee
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

should = require "should"

mut = require "../lib/petscii"

describe "PETSCII", ->
    it "should obey the laws of logic", ->
        false.should.eql false
        true.should.eql true

    it "should export a PETSCII object", ->
        mut.should.have.property "PETSCII"
        mut.PETSCII.should.be.an.Object()

    describe "PETSCII", ->
        {PETSCII} = mut

        it "should have two modes", ->
            PETSCII.should.have.property "MODE"
            PETSCII.MODE.should.be.an.Array()
            PETSCII.MODE[0].should.eql "shifted"
            PETSCII.MODE[1].should.eql "unshifted"

        it "should have a table where each mode has 256 entries", ->
            PETSCII.should.have.property "TABLE"
            PETSCII.TABLE.should.be.an.Object()
            for mode in PETSCII.MODE
                PETSCII.TABLE[mode].length.should.eql 256

        it "should have decode and encode functions", ->
            PETSCII.should.have.property "decode"
            PETSCII.decode.should.be.a.Function()
            PETSCII.should.have.property "encode"
            PETSCII.encode.should.be.a.Function()

        describe "decode", ->
            {decode} = PETSCII

            it "should throw on a bad mode", ->
                should.throws(-> decode(null, Buffer.from([0x61, 0x73, 0x78, 0x7a])))

            it "should throw on bad input", ->
                should.throws(-> decode("unshifted", "poopy pants"))

            it "should decode card symbols correctly", ->
                decode("unshifted", Buffer.from([0x61, 0x73, 0x78, 0x7a])).should.eql "♠♥♣♦"

            it "should decode other symbols correctly", ->
                decode("shifted", Buffer.from([0x61, 0x73, 0x78, 0x7a])).should.eql "ASXZ"

            it "should decode control characters correctly", ->
                decode("shifted", Buffer.from([0x68, 0x45, 0x4c, 0x4c, 0x4f, 0x0a, 0x77, 0x4f, 0x52, 0x4c, 0x44, 0x0a])).should.eql "Hello\nWorld\n"

        describe "encode", ->
            {encode} = PETSCII

            it "should throw on a bad mode", ->
                should.throws(-> encode(null, "♠♥♣♦"))

            it "should throw on bad input", ->
                should.throws(-> encode("unshifted", Buffer.from([0x61, 0x73, 0x78, 0x7a])))

            it "should encode card symbols correctly", ->
                encode("unshifted", "♠♥♣♦").should.eql Buffer.from([0x61, 0x73, 0x78, 0x7a])

            it "should encode other symbols correctly", ->
                encode("shifted", "ASXZ").should.eql Buffer.from([0x61, 0x73, 0x78, 0x7a])

            it "should encode control characters correctly", ->
                encode("shifted", "Hello\nWorld\n").should.eql Buffer.from([0x68, 0x45, 0x4c, 0x4c, 0x4f, 0x0a, 0x77, 0x4f, 0x52, 0x4c, 0x44, 0x0a])

            it "should encode unknown characters as question marks", ->
                encode("shifted", "$£￥").should.eql Buffer.from([0x24, 0x5c, 0x3f])

            it "should encode a friendly message correctly", ->
                encode("shifted", "Hello, world!").should.eql Buffer.from([0x68, 0x45, 0x4c, 0x4c, 0x4f, 0x2c, 0x20, 0x57, 0x4f, 0x52, 0x4c, 0x44, 0x21])

            it "should encode a friendly message incorrectly", ->
                encode("unshifted", "Hello, world!").should.eql Buffer.from([0x48, 0x3f, 0x3f, 0x3f, 0x3f, 0x2c, 0x20, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x21])

#----------------------------------------------------------------------------
# end of petsciiTest.coffee
