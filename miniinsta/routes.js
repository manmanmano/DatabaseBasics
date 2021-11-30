let sql = require('./sql');

function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}

exports.index =  function(req, res) {
    res.send('<h1>Hello from MiniInsta api</h1>');
};

exports.index =  function(req, res) {

    let model = {
        title: 'API Functions',
        api: [
            { name: 'Users', url: '/api/users' },
            { name: 'User by ID', url: '/api/users/42' },
            { name: 'User by Username', url: '/api/users/cbaccup3b' },
            { name: 'Front Page', url: '/api/frontpage' },
            { name: 'Profile Page', url: '/api/profilepage/cbaccup3b' },
            { name: 'Post Details', url: '/api/posts/19' },
            { name: 'General Statistics', url: '/api/stats' },
            { name: 'Top 10 Users with most posts', url: '/api/stats/top10/postingusers' },
            { name: 'User Registrations', url: '/api/stats/registrations' },
            { name: 'Gender Division', url: '/api/stats/genederdivision' },
        ]
    };

    res.render('api-index', model);
};

exports.frontpage = function(req, res) {
    let query = 'select * form User';

    if (typeof(req.params.id) !== 'undefined') {
        if (isNumber(req.params.id)) {
            query = query.concat(' where ID=' + req.params.id);
        } else {
            query = query.concat('where Username=\'' + req.params.id + '\'');
        }
    }

    sql.querySql(query, function(date)  {
        if (data !== undefined) {
            console.log('DATA rows effected: ' + data.length);
            res.send(data);
        }
    }, function(error) {
        console.log('ERROR: ' + error);
        res.status(500).send('ERROR: ' + error);
    });
};

exports.default = function(req, res) {
    res.status(404).send('<h1>Such path does not exist!</h1>');
};
