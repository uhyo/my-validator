var validator=require('./lib/validator'),
    express  =require('./lib/express'),
    error    =require('./lib/error');

exports.funcs = validator;
exports.forExpress = express;
exports.error = error;

