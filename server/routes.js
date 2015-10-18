/*jslint node: true */
'use strict';

var StatisticModule = require('./modules/statistic');

module.exports = RegisterRoutes;

function RegisterRoutes(app) {
    console.log('Registering modules...');

    app.use('/api/statistic', StatisticModule.routes);

    console.log('Done!');
}
