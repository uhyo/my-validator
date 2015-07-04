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
    describe 'character',->
        describe 'ASCII printable',->
            it 'ok',->
                assert.equal v.isASCIIPrintable("foobar"),null
                assert.equal v.isASCIIPrintable(" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"),null

            it 'control sequence',->
                assert.deepEqual v.isASCIIPrintable("foobar\u0000"),{
                    name: "ValidationError"
                    code: error.code.character.asciiPrintable
                    value: "foobar\u0000"
                }
            it 'nonASCII characters',->
                assert.deepEqual v.isASCIIPrintable("鹿苑寺金閣"),{
                    name: "ValidationError"
                    code: error.code.character.asciiPrintable
                    value: "鹿苑寺金閣"
                }
        describe 'hiragana',->
            it 'ok',->
                assert.equal v.isHiragana(""),null
                assert.equal v.isHiragana("いろはにほへとちりぬるを"),null
                assert.equal v.isHiragana("あいうえおかきくけこさっしすせそたちつてとなにぬねのはひふへほまみむめもやゃゆゅよょらりるれろぁぃぅぇぉわゐうゑをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ"),null
            it 'spaces',->
                assert.deepEqual v.isHiragana("あいう　えお"),{
                    name: "ValidationError"
                    code: error.code.character.hiragana
                    value: "あいう　えお"
                }
                assert.equal v.isHiragana("あいう　えお",true),null
            it 'non-hiragana character',->
                assert.deepEqual v.isHiragana("鹿苑寺金閣"),{
                    name: "ValidationError"
                    code: error.code.character.hiragana
                    value: "鹿苑寺金閣"
                }
        describe 'katakana',->
            it 'ok',->
                assert.equal v.isKatakana(""),null
                assert.equal v.isKatakana("アイウエオカキクケコサシスセソタチツッテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰウヱヲンァィゥェォャュョガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポ"),null
            it 'spaces',->
                assert.deepEqual v.isKatakana("タナカ　タロウ"),{
                    name: "ValidationError"
                    code: error.code.character.katakana
                    value: "タナカ　タロウ"
                }
                assert.equal v.isKatakana("タナカ　タロウ",true),null
            it 'non-katakana character',->
                assert.deepEqual v.isKatakana("鹿苑寺金閣"),{
                    name: "ValidationError"
                    code: error.code.character.katakana
                    value: "鹿苑寺金閣"
                }

    describe 'formats',->
        describe 'number',->
            describe 'basic',->
                it 'ok',->
                    assert.equal v.isNumber("123456"),null
                    assert.equal v.isNumber("00001"),null
                    assert.equal v.isNumber("0"),null
                    assert.equal v.isNumber("03.14159"),null
                    assert.equal v.isNumber("333."),null
                    assert.equal v.isNumber(".123"),null
                it 'non-number character',->
                    assert.deepEqual v.isNumber("foobar"),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "foobar"
                    }
                    assert.deepEqual v.isNumber("123foobar456"),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "123foobar456"
                    }
                it 'invalid format',->
                    assert.deepEqual v.isNumber(""),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: ""
                    }
                    assert.deepEqual v.isNumber("."),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "."
                    }
                    assert.deepEqual v.isNumber("123.456.7"),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "123.456.7"
                    }
                    assert.deepEqual v.isNumber("-33.4"),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-33.4"
                    }
            describe 'allowNegatives',->
                it 'ok',->
                    assert.equal v.isNumber("123",true),null
                    assert.equal v.isNumber("+00001",true),null
                    assert.equal v.isNumber("-0",true),null
                    assert.equal v.isNumber("-03.14159",true),null
                    assert.equal v.isNumber("-333.",true),null
                    assert.equal v.isNumber("+.123",true),null
                it 'non-number character',->
                    assert.deepEqual v.isNumber("-foobar",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-foobar"
                    }
                    assert.deepEqual v.isNumber("-123foobar+456",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-123foobar+456"
                    }
                it 'invalid format',->
                    assert.deepEqual v.isNumber(".",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "."
                    }
                    assert.deepEqual v.isNumber("-",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-"
                    }
                    assert.deepEqual v.isNumber("-.",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-."
                    }
                    assert.deepEqual v.isNumber("-123.444.5",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-123.444.5"
                    }
                    assert.deepEqual v.isNumber("-+3",true),{
                        name:"ValidationError"
                        code: error.code.format.number
                        value: "-+3"
                    }
        describe 'integer',->
            describe 'basic',->
                it 'ok',->
                    assert.equal v.isInteger("123456"),null
                    assert.equal v.isInteger("00001"),null
                    assert.equal v.isInteger("0"),null
                it 'non-number character',->
                    assert.deepEqual v.isInteger("foobar"),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "foobar"
                    }
                it 'invalid format',->
                    assert.deepEqual v.isInteger(""),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: ""
                    }
                    assert.deepEqual v.isInteger("123.4"),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "123.4"
                    }
                    assert.deepEqual v.isInteger("-5"),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "-5"
                    }
            describe 'allowNegatives',->
                it 'ok',->
                    assert.equal v.isInteger("123",true),null
                    assert.equal v.isInteger("+00001",true),null
                    assert.equal v.isInteger("-0",true),null
                it 'non-number character',->
                    assert.deepEqual v.isInteger("-foobar",true),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "-foobar"
                    }
                it 'invalid format',->
                    assert.deepEqual v.isInteger(".",true),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "."
                    }
                    assert.deepEqual v.isInteger("-",true),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "-"
                    }
                    assert.deepEqual v.isInteger("-.",true),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "-."
                    }
                    assert.deepEqual v.isInteger("-123.444.5",true),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "-123.444.5"
                    }
                    assert.deepEqual v.isInteger("-+3",true),{
                        name:"ValidationError"
                        code: error.code.format.integer
                        value: "-+3"
                    }
