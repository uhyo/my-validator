var error = require('./error');
var Validator = (function () {
    function Validator() {
    }
    Validator.prototype.matches = function (value, pattern) {
        if (pattern.test(value)) {
            return null;
        }
        return new error.PatternMatchError(error.code.pattern.unmatch, value, pattern);
    };
    return Validator;
})();
module.exports = Validator;
