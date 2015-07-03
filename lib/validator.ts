import error=require('./error');

class Validator{
    // matches pattern
    matches(value:string,pattern:RegExp):error.ValidationError|error.PatternMatchError{
        //test if value is string
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        //match regexp
        if(pattern.test(value)){
            return null;
        }
        return new error.PatternMatchError(error.code.pattern.unmatch,value,pattern);
    }

    // within length
    minLength(value:string,min:number):error.ValidationError|error.LengthError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        var len=this.unicodeLength(value);
        if(len<min){
            return new error.LengthError(error.code.length.min, value, min, null);
        }
        return null;
    }
    length(value:string,max:number,min?:number):error.ValidationError|error.LengthError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        var len=this.unicodeLength(value);
        if(max!=null && max<len){
            return new error.LengthError(error.code.length.max, value, min||null, max||null);
        }
        if(min!=null && len<min){
            return new error.LengthError(error.code.length.min,value, min, max||null);
        }
        return null;
    }

    //util methods
    //length taking account of Surrogate pairs
    private unicodeLength(value:string):number{
        var result:number=0;
        for(var i=0,l=value.length;i<l;i++){
            let c=value.charCodeAt(i);
            result++;
            if(0xD800<=c && c<=0xDBFF){
                let n=value.charCodeAt(i+1);
                if(0xDC00<=n && n<=0xDFFF){
                    //implicitly handling end of string
                    i++;
                }
            }
        }
        return result;
    }
}


export = Validator;
