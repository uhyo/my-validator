assert=require 'assert'

error=require '../lib/error'
expressv=require '../lib/express'

makeObj = (query={},body={},params={})->
    return {
        req: {
            query: query
            body: body
            params: params
        }
        res: {
            send: (value)->
                @result=value
        }
    }


describe 'express',->
    req=null
    res=null
    beforeEach ->
        {req:_req, res:_res} = makeObj({
            foo: "bar"
            hoge: "12345"
            baz: ""
        },{
            foo: "fooooooooooooooooooooooooo↑↑↑"
        },{
            hoge: "foo123@example.com"
        })
        req=_req
        res=_res
    describe 'query',->
        it 'basic validation ok',(done)->
            expressv req,res,->
                req.validateQuery("foo").length(10).matches(/^[a-zA-Z]+$/)
                req.validateQuery("hoge").isInteger()

                assert.deepEqual req._validationErrors,[]
                done()

        it 'basic validation fails',(done)->

            expressv req,res,->
                req.validateQuery("foo").length(5,10).isInteger()
                req.validateQuery("hoge").isHiragana()
                req.validateQuery("baz").isInteger()

                assert.deepEqual req._validationErrors,[{
                    type: "query"
                    name: "foo"
                    error: {
                        name: "LengthError"
                        code: error.code.length.min
                        value: "bar"
                        min: 5
                        max: 10
                    }
                },{
                    type: "query"
                    name: "foo"
                    error: {
                        name: "ValidationError"
                        code: error.code.format.integer
                        value: "bar"
                    }
                },{
                    type: "query"
                    name: "hoge"
                    error: {
                        name: "ValidationError"
                        code: error.code.character.hiragana
                        value: "12345"
                    }
                },{
                    type: "query"
                    name: "baz"
                    error: {
                        name: "ValidationError"
                        code: error.code.format.integer
                        value: ""
                    }
                }]
                done()
        describe 'optional',->
            it 'optional-first',(done)->
                expressv req,res,->
                    req.validateQuery("foo").minLength(5)
                    req.validateQuery("baz").optional().isInteger()

                    assert.deepEqual req._validationErrors,[{
                        type: "query"
                        name: "foo"
                        error: {
                            name: "LengthError"
                            code: error.code.length.min
                            value: "bar"
                            min: 5
                            max: null
                        }
                    }]
                    done()
            it 'optional-middle',(done)->
                expressv req,res,->
                    req.validateQuery("foo").minLength(5)
                    req.validateQuery("baz").isInteger().optional().isEmail()

                    assert.deepEqual req._validationErrors,[{
                        type: "query"
                        name: "foo"
                        error: {
                            name: "LengthError"
                            code: error.code.length.min
                            value: "bar"
                            min: 5
                            max: null
                        }
                    }]
                    done()
            it 'optional-last',(done)->
                expressv req,res,->
                    req.validateQuery("foo").minLength(5)
                    req.validateQuery("baz").isInteger().optional()

                    assert.deepEqual req._validationErrors,[{
                        type: "query"
                        name: "foo"
                        error: {
                            name: "LengthError"
                            code: error.code.length.min
                            value: "bar"
                            min: 5
                            max: null
                        }
                    }]
                    done()
    describe 'body',->
        it 'basic validation ok',(done)->
            expressv req,res,->
                req.validateBody("foo").length(100)

                assert.deepEqual req._validationErrors,[]
                done()
        it 'basic validation error',(done)->
            expressv req,res,->
                req.validateBody("foo").length(15)

                assert.deepEqual req._validationErrors,[{
                    type: "body"
                    name: "foo"
                    error: {
                        name: "LengthError"
                        code: error.code.length.max
                        value: "fooooooooooooooooooooooooo↑↑↑"
                        min: null
                        max: 15
                    }
                }]
                done()
    describe 'params',->
        it 'basic validation ok',(done)->
            expressv req,res,->
                req.validateParams("hoge").isEmail()

                assert.deepEqual req._validationErrors,[]
                done()
        it 'basic validation error',(done)->
            expressv req,res,->
                req.validateParams("hoge").isInteger()

                assert.deepEqual req._validationErrors,[{
                    type: "params"
                    name: "hoge"
                    error: {
                        name: "ValidationError"
                        code: error.code.format.integer
                        value: "foo123@example.com"
                    }
                }]
                done()
