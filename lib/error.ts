export class ValidationError{
    public name:string="ValidationError";
    public code:string;

    public value:string;

    constructor(code:string,value:string){
        this.code=code;
        this.value=value;
    }

    public toString():string{
        return "["+this.name+" "+this.code+"]";
    }
}

export class PatternMatchError extends ValidationError{
    public pattern:RegExp;
    constructor(code:string,value:string,pattern:RegExp){
        super(code,value);
        this.pattern=pattern;
    }
}

export module code{
    export var pattern={
        unmatch: "ERR_PATTERN_UNMATCH"
    };
}
