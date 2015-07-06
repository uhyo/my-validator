//validator for express app
import validator=require('./validator');
import error=require('./error');

function middleware(req:any, res:any, next:Function):void{
    req._validationErrors=[];
    req.validateQuery=validateQuery;
    req.validateBody=validateBody;
    req.validateParams=validateParams;
    req.throwValidationErrors=throwValidationErrors;
    next();
}

//Request methods
function validateQuery(name:string):Validation{
    return new Validation(this, "query", name, this.query[name]);
}

function validateBody(name:string):Validation{
    return new Validation(this, "body", name, this.body[name]);
}

function validateParams(name:string):Validation{
    return new Validation(this, "params", name, this.params[name]);
}

function throwValidationErrors():Validation{
    if(this._validationErrors.length===0)return;
    var e:any=new Error("Validation Error");
    e.name="ValidationError";
    e.errors=this._validationErrors;
    throw e;
}

class Validation{
    private optional_flag:boolean=false;
    constructor(private req:any, private type:string, private name:string, private value:string){
        for(var key in validator){
            this[key] = ((f:Function,...args:any[])=>{
                if(this.optional_flag && this.value==="")return this;
                var result = f(value,...args);
                if(result!=null){
                    req._validationErrors.push({
                        type:type,
                        name:name,
                        error:result
                    });
                }
                return this;
            }).bind(this,validator[key]);
        }
    }
    public optional():Validation{
        var type=this.type, name=this.name;
        this.optional_flag=true;
        this.req._validationErrors=this.req._validationErrors.filter((obj)=>{
            return obj.type!==type || obj.name!==name;
        });
        return this;
    }
}

export = middleware;
