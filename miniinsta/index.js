let express = require('express');
let routes = require('./routes');

let app = express();

app.set('view engine', 'hbs');

app.get('/', routes.index);
app.get('/api/users/:id?', routes.users);

app.get('/api/frontpage', routes.frontpage);
//app.get('/api/profile/:id', routes.profilePage);
//app.get('/api/posts/:id', routes.postDetails);
//app.get('/api/stats', routes.statistics);
//app.get('/api/stats/top10/postingusers', routes.top10UsersWithMostPosts);
//app.get('/api/users/registrations', routes.userRegistrations);
//app.get('/api/stats/genderdivision', routes.genderDivision);

//app.get('/api/users/:id([0-9]{1,9})?', routes.usersByID);
//app.get('/api/users/:username?', routes.usersByUsername);

app.get('*', routes.default);

let server = app.listen(3000, function() {
    console.log('Listening on port 3000');
})
