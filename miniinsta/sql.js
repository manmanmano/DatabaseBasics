let mysql = require('mysql');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'testapp',
  password : 'testApp123#',
  database : 'miniinsta',
  multipleStatements: true
});

exports.querySql = function(query, onData, onError) {
    try {
        pool
            .query(query, function(error, results, fields) {
                if (error) {
                    onError(error);
                    return;
                }
                onData(results);
            });
    }
    catch (err) {
        if (onError !== undefined)
            onError(err);
    }
};
