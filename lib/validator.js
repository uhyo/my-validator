var error = require('./error');
var Validator = (function () {
    function Validator() {
    }
    // matches pattern
    Validator.prototype.matches = function (value, pattern) {
        //test if value is string
        if ("string" !== typeof value) {
            return new error.ValidationError(error.code.type, value);
        }
        //match regexp
        if (pattern.test(value)) {
            return null;
        }
        return new error.PatternMatchError(error.code.pattern.unmatch, value, pattern);
    };
    // within length
    Validator.prototype.minLength = function (value, min) {
        if ("string" !== typeof value) {
            return new error.ValidationError(error.code.type, value);
        }
        var len = this.unicodeLength(value);
        if (len < min) {
            return new error.LengthError(error.code.length.min, value, min, null);
        }
        return null;
    };
    Validator.prototype.length = function (value, max, min) {
        if ("string" !== typeof value) {
            return new error.ValidationError(error.code.type, value);
        }
        var len = this.unicodeLength(value);
        if (max != null && max < len) {
            return new error.LengthError(error.code.length.max, value, min || null, max || null);
        }
        if (min != null && len < min) {
            return new error.LengthError(error.code.length.min, value, min, max || null);
        }
        return null;
    };
    //character types
    Validator.prototype.isASCIIPrintable = function (value) {
        if ("string" !== typeof value) {
            return new error.ValidationError(error.code.type, value);
        }
        if (/^[\u0020-\u007E]*$/.test(value)) {
            return null;
        }
        return new error.ValidationError(error.code.character.asciiPrintable, value);
    };
    //string forms
    Validator.prototype.isNumber = function (value, allowNegatives) {
        if ("string" !== typeof value) {
            return new error.ValidationError(error.code.type, value);
        }
        if (allowNegatives) {
            if (/^[\+\-]?(?:\d+(?:\.\d*)?|\.\d+)$/.test(value)) {
                return null;
            }
        }
        else {
            if (/^(?:\d+(?:\.\d*)?|\.\d+)$/.test(value)) {
                return null;
            }
        }
        return new error.ValidationError(error.code.format.number, value);
    };
    Validator.prototype.isInteger = function (value, allowNegatives) {
        if ("string" !== typeof value) {
            return new error.ValidationError(error.code.type, value);
        }
        if (allowNegatives) {
            if (/^[\+\-]?\d+$/.test(value)) {
                return null;
            }
        }
        else {
            if (/^\d+$/.test(value)) {
                return null;
            }
        }
        return new error.ValidationError(error.code.format.integer, value);
    };
    //util methods
    //length taking account of Surrogate pairs
    Validator.prototype.unicodeLength = function (value) {
        var result = 0;
        for (var i = 0, l = value.length; i < l; i++) {
            var c = value.charCodeAt(i);
            result++;
            if (0xD800 <= c && c <= 0xDBFF) {
                var n = value.charCodeAt(i + 1);
                if (0xDC00 <= n && n <= 0xDFFF) {
                    //implicitly handling end of string
                    i++;
                }
            }
        }
        return result;
    };
    return Validator;
})();
module.exports = Validator;
