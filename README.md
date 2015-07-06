# my-validator v0.1.0

`my-validator` is my simple validator for me.

It provides functions to validate string. It also works with express. 

## Installation
```sh
npm install my-validator
```

## Usage

Just use validator functions:

```js
var validator=require('my-validator');

var funcs=validator.funcs;

// returns null if valid
console.log(funcs.isInteger("123"));	// null

// returns error object if not valid
console.log(funcs.isInteger("foo"));
/* returns {
       name: "ValidationError",
       code: "ERR_FORMAT_INTEGER",
       value: "foo"
   } */


Use with express:

```js
var express=require('express'),
    validator=require('my-validator');

var app=express();

app.use(validator.forExpress);	//register validator middleware

app.get("/",function(req,res){
    //validate query/body/params
    req.validateQuery("foo").length(100);	//limit length to 100

    // throw if validation error: handle it in error-handling middleware
    req.throwValidationErrors();

    // or handle errors manually
    if(req._validationErrors.length>0){
        res.json({
            validationErrors: req._validationErrors
        });
        return;
    }
    res.send("ok");
});
```

## validators
All of these functions return null if valid or error object if not valid.
### matches(value:string, pattern:RegExp)
Checks if `value` matches `pattern`.

Possible error code is `error.code.pattern.unmatch`.

### isnotEmpty(value:string)
Checks if `value !== ""`.

Possible error code is `error.code.empty`.

### length(value:string[, min:number], max:number)
Checks if the length of `value` is within the range specified.

Possible error code is `error.code.length.min` if `value.length < min` and `error.code.length.max` if `max < value.length`.

### minLength(value:string, min:number)
Just checks lower bound of the length.

Possible error code is `error.code.length.min`.

### lines(value: string, max:number)
Checks if the number of lines that `value` contains does not exceed `max`.

Possible error code is `error.code.lines.max`.

### isASCIIPrintable(value:string)
Checks if all the characters of `value` is ASCII printable character (`0x20 <= code <= 0x7E`).

Possible error code is `error.code.character.asciiPrintable`.

### isHiragana(value:string[, allowSpace: boolean])
Checks if all the characters of `value` is ひらがな for me. If `allowSpace` is true, it also allows U+3000 IDEOGRAPHIC SPACE. Defaults to false.

Possible error code is `error.code.character.hiragana`.

### isKatakana(value:string[, allowSpace: boolean])
Checks if all the characters of `value` is カタカナ for me.

Possible error code is `error.code.character.katakana`.

### isNumber(value:string[, allowNegatives: boolean])
Checks if `value` is a valid expression of number. If `allowNegatives` is true, it allows negative numbers (defaults to false).

Possible error code is `error.code.format.number`.

### isInteger(value:string[, allowNegatives: boolean])
Checks if `value` is a valid expression of integer If `allowNegatives` is true, it allows negative numbers (defaults to false).

Possible error code is `error.code.format.integer`.

### isEmail(value:string)
Checks if `value` is a valid expression of email address.

Possible error code is `error.code.format.email`.

## Error objects (error = validator.error)
### error.ValidationError
The Error object returned by validator functions. It has following properties:

* name:string  the name of error.
* code:string  the error code that represents the cause of error.
* value:string  the value that is validated.

## APIs for express

### validator.forExpress
Middleware function for express application.

### req.validateQuery(name:string)
Returns a **validator object** for `req.query[name]`. The validator object is equipped with any validator function, of which first argument (value) is omitted, and chainable.

### req.validateBody(name:string)
Returns a validator object for `req.body[name]`.

### req.validateParams(name:string)
Returns a validator object for `req.params[name]`.

### req._validationErrors
Array of all validation errors detected by validator objects.

### req.throwValidationErrors()
Throws if there is any validation error. Otherwise do nothing.

## Other APIs
### validator.addCustomValidator(name:string[, code:string], func:Function)
Adds new validator represented by `func`. `func` should return `true` if valid or `false` if invalid.

The custom validator can be used in the same way as build-in validators.

## License
MIT
