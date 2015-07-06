//validator for express app
var validator = require('./validator');
function middleware(req, res, next) {
    req._validationErrors = [];
    req.validateQuery = validateQuery;
    req.validateBody = validateBody;
    req.validateParams = validateParams;
    req.throwValidationErrors = throwValidationErrors;
    next();
}
//Request methods
function validateQuery(name) {
    return new Validation(this, "query", name, this.query[name]);
}
function validateBody(name) {
    return new Validation(this, "body", name, this.body[name]);
}
function validateParams(name) {
    return new Validation(this, "params", name, this.params[name]);
}
function throwValidationErrors() {
    if (this._validationErrors.length === 0)
        return;
    var e = new Error("Validation Error");
    e.name = "ValidationError";
    e.errors = this._validationErrors;
    throw e;
}
var Validation = (function () {
    function Validation(req, type, name, value) {
        var _this = this;
        this.req = req;
        this.type = type;
        this.name = name;
        this.value = value;
        this.optional_flag = false;
        for (var key in validator) {
            this[key] = (function (f) {
                var args = [];
                for (var _i = 1; _i < arguments.length; _i++) {
                    args[_i - 1] = arguments[_i];
                }
                if (_this.optional_flag && _this.value === "")
                    return _this;
                var result = f.apply(void 0, [value].concat(args));
                if (result != null) {
                    req._validationErrors.push({
                        type: type,
                        name: name,
                        error: result
                    });
                }
                return _this;
            }).bind(this, validator[key]);
        }
    }
    Validation.prototype.optional = function () {
        var type = this.type, name = this.name;
        this.optional_flag = true;
        this.req._validationErrors = this.req._validationErrors.filter(function (obj) {
            return obj.type !== type || obj.name !== name;
        });
        return this;
    };
    return Validation;
})();
module.exports = middleware;
