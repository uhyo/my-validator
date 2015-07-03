assert=require 'assert'

Validator=require '../lib/validator'
error=require '../lib/error'

v=new Validator

describe 'Validator',->
    describe 'matches',->
        it 'matching',->
            assert.equal v.matches("foobar",/foo/),null
        it 'unmatching',->
            p= /^foo$/
            assert.deepEqual v.matches("foobar",p),{
                name: "PatternMatchError"
                code: error.code.pattern.unmatch
                value: "foobar"
                pattern: p
            }
    describe 'length',->
        describe 'max',->
            it 'ok',->
                assert.equal v.length("foobar",10),null
                assert.equal v.length("foobar",6),null
            it 'too long',->
                assert.deepEqual v.length("foobar",5),{
                    name: "LengthError"
                    code: error.code.length.max
                    value: "foobar"
                    min: null
                    max: 5
                }
            it 'handle surrogate pairs',->
                assert.equal v.length("a\ud834\udf06c",3),null
                assert.deepEqual v.length("a\ud834\udf06c",2),{
                    name: "LengthError"
                    code: error.code.length.max
                    value: "a\ud834\udf06c"
                    min: null
                    max: 2
                }
        describe 'min1',->
            it 'ok',->
                assert.equal v.length("foobar",null,5),null
                assert.equal v.length("foobar",null,6),null
            it 'too short',->
                assert.deepEqual v.length("foobar",null,10),{
                    name: "LengthError"
                    code: error.code.length.min
                    value: "foobar"
                    min: 10
                    max: null
                }
            it 'handle surrogate pairs',->
                assert.equal v.length("a\ud834\udf06c",null,3),null
                assert.deepEqual v.length("a\ud834\udf06c",null,4),{
                    name: "LengthError"
                    code: error.code.length.min
                    value: "a\ud834\udf06c"
                    min: 4
                    max: null
                }
        describe 'min2',->
            it 'ok',->
                assert.equal v.minLength("foobar",5),null
                assert.equal v.minLength("foobar",6),null
            it 'too short',->
                assert.deepEqual v.minLength("foobar",10),{
                    name: "LengthError"
                    code: error.code.length.min
                    value: "foobar"
                    min: 10
                    max: null
                }
            it 'handle surrogate pairs',->
                assert.equal v.minLength("a\ud834\udf06c",3),null
                assert.deepEqual v.minLength("a\ud834\udf06c",4),{
                    name: "LengthError"
                    code: error.code.length.min
                    value: "a\ud834\udf06c"
                    min: 4
                    max: null
                }
        describe 'min & max',->
            it 'ok',->
                assert.equal v.length("foobar",10,5),null
                assert.equal v.length("foobar",6,6),null
            it 'too long',->
                assert.deepEqual v.length("foobar",5,3),{
                    name: "LengthError"
                    code: error.code.length.max
                    value: "foobar"
                    min: 3
                    max: 5
                }
            it 'too short',->
                assert.deepEqual v.length("foobar",20,10),{
                    name: "LengthError"
                    code: error.code.length.min
                    value: "foobar"
                    min: 10
                    max: 20
                }
            it 'handle surrogate pairs',->
                assert.equal v.length("a\ud834\udf06c",6,3),null
                assert.deepEqual v.length("a\ud834\udf06c",10,4),{
                    name: "LengthError"
                    code: error.code.length.min
                    value: "a\ud834\udf06c"
                    min: 4
                    max: 10
                }
