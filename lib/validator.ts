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

    //character types
    isASCIIPrintable(value:string):error.ValidationError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        if(/^[\u0020-\u007E]*$/.test(value)){
            return null;
        }
        return new error.ValidationError(error.code.character.asciiPrintable,value);
    }
    isHiragana(value:string,allowSpace?:boolean):error.ValidationError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        if(allowSpace){
            if(/^[\u3000\u3041-\u3096\u3099-\u309f]*$/.test(value)){
                return null;
            }
        }else{
            if(/^[\u3041-\u3096\u3099-\u309f]*$/.test(value)){
                return null;
            }
        }
        return new error.ValidationError(error.code.character.hiragana,value);
    }
    isKatakana(value:string,allowSpace?:boolean):error.ValidationError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        if(allowSpace){
            if(/^[\u3000\u30a1-\u30ff]*$/.test(value)){
                return null;
            }
        }else{
            if(/^[\u30a1-\u30ff]*$/.test(value)){
                return null;
            }
        }
        return new error.ValidationError(error.code.character.katakana,value);
    }

    //string forms
    isNumber(value:string,allowNegatives?:boolean):error.ValidationError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        if(allowNegatives){
            if(/^[\+\-]?(?:\d+(?:\.\d*)?|\.\d+)$/.test(value)){
                return null;
            }
        }else{
            if(/^(?:\d+(?:\.\d*)?|\.\d+)$/.test(value)){
                return null;
            }
        }
        return new error.ValidationError(error.code.format.number,value);
    }
    isInteger(value:string,allowNegatives?:boolean):error.ValidationError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        if(allowNegatives){
            if(/^[\+\-]?\d+$/.test(value)){
                return null;
            }
        }else{
            if(/^\d+$/.test(value)){
                return null;
            }
        }
        return new error.ValidationError(error.code.format.integer,value);
    }
    isEmail(value:string):error.ValidationError{
        if("string"!==typeof value){
            return new error.ValidationError(error.code.type, value);
        }
        if(value.length>254){
            return new error.ValidationError(error.code.format.email,value);
        }
        //dot-atom+domain
        var r=value.match(/^([a-zA-Z0-9\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~\.]+)\@([a-zA-Z0-9][a-zA-Z0-9\-]*(?:\.[a-zA-Z0-9][a-zA-Z0-9\-]*)*|\[\d+\.\d+\.\d+\.\d+\])$/);
        var local,domain;
        if(r){
            local=r[1], domain=r[2];
            //test local
            if(/^\.|\.$|\.\./.test(local)){
                return new error.ValidationError(error.code.format.email,value);
            }
            //test domain
            if(domain[0]==="["){
                let s=domain.slice(1,-1).split(".");
                let s0=+s[0], s1=+s[1], s2=+s[2], s3=+s[3];
                if(s0<0 || 255<s0 || s1<0 || 255<s1 || s2<0 || 255<s2 || s3<0 || 255<s3){
                    //invalid ip addr
                    return new error.ValidationError(error.code.format.email,value);
                }
            }
            if(local.length>64 || domain.length>253){
                return new error.ValidationError(error.code.format.email,value);
            }
            return null;
        }
        //quoted-string+domain
        r=value.match(/^("(?:[a-zA-Z0-9\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~\.\(\)\<\>\[\]\:\;\@\,\ ]|\\[\u0020-\u007e])+\")@([a-zA-Z0-9][a-zA-Z0-9\-]*(?:\.[a-zA-Z0-9][a-zA-Z0-9\-]*)*|\[\d+\.\d+\.\d+\.\d+\])$/);
        if(r){
            local=r[1], domain=r[2];
            //test domain
            if(domain[0]==="["){
                let s=domain.slice(1,-1).split(".");
                let s0=+s[0], s1=+s[1], s2=+s[2], s3=+s[3];
                if(s0<0 || 255<s0 || s1<0 || 255<s1 || s2<0 || 255<s2 || s3<0 || 255<s3){
                    //invalid ip addr
                    return new error.ValidationError(error.code.format.email,value);
                }
            }
            if(local.length>64 || domain.length>253){
                return new error.ValidationError(error.code.format.email,value);
            }
            return null;
        }
        return new error.ValidationError(error.code.format.email,value);
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
