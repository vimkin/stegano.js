'use strict';

var express = require('express'),
    router = express.Router(),
    controller = require('./controller');

router.post('/', controller.addStatistic);
router.get('/', controller.getStatistic);

module.exports.routes = router;

