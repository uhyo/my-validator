import error=require('./error');

import ValidationError = error.ValidationError;

class Validator{
    matches(value:string,pattern:RegExp):ValidationError{
        if(pattern.test(value)){
            return null;
        }
        return new error.PatternMatchError(error.code.pattern.unmatch,value,pattern);
    }
}


export = Validator;
