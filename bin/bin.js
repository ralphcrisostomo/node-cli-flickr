#!/usr/bin/env node
process.env.NODE_ENV = 'production';
var program = require('commander');
var App     = require('../dist/app');

program
    .version('0.0.1');


program
    .command('*')
    .description('Download all videos')
    .action(function(username){
        new App(username);
    });

program.parse(process.argv);

if (!process.argv.slice(2).length) {
    program.outputHelp();
}
