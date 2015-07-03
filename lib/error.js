var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ValidationError = (function () {
    function ValidationError(code, value) {
        this.name = "ValidationError";
        this.code = code;
        this.value = value;
    }
    ValidationError.prototype.toString = function () {
        return "[" + this.name + " " + this.code + "]";
    };
    return ValidationError;
})();
exports.ValidationError = ValidationError;
var PatternMatchError = (function (_super) {
    __extends(PatternMatchError, _super);
    function PatternMatchError(code, value, pattern) {
        _super.call(this, code, value);
        this.pattern = pattern;
    }
    return PatternMatchError;
})(ValidationError);
exports.PatternMatchError = PatternMatchError;
var code;
(function (code) {
    code.pattern = {
        unmatch: "ERR_PATTERN_UNMATCH"
    };
})(code = exports.code || (exports.code = {}));
