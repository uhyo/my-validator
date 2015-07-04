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
    public name:string="PatternMatchError";
    constructor(code:string,value:string,public pattern:RegExp){
        super(code,value);
    }
}

export class LengthError extends ValidationError{
    public name:string="LengthError";
    constructor(code:string,value:string,public min:number,public max:number){
        super(code,value);
    }
}

export module code{
    export var type="ERR_TYPE";
    export var pattern={
        unmatch: "ERR_PATTERN_UNMATCH"
    };
    export var length={
        min: "ERR_LENGTH_MIN",
        max: "ERR_LENGTH_MAX"
    };
    export var character={
        asciiPrintable: "ERR_CHARACTER_ASCIIPRINTABLE",
        hiragana: "ERR_CHARACTER_HIRAGANA",
        katakana: "ERR_CHARACTER_KATAKANA"
    };

    export var format={
        number: "ERR_FORMAT_NUMBER",
        integer: "ERR_FORMAT_INTEGER"
    }
}
