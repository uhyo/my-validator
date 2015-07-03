assert=require 'assert'

Validator=require '../lib/validator'
error=require '../lib/error'

v=new Validator

describe 'Validator',->
    describe 'matches',->
        it 'matching',->
            assert.equal null,v.matches("foobar",/foo/)
        it 'unmatching',->
            p= /^foo$/
            r=v.matches "foobar",p
            assert.ok r instanceof error.PatternMatchError
            assert.deepEqual r,{
                name: "ValidationError"
                code: error.code.pattern.unmatch
                value: "foobar"
                pattern: p
            }
