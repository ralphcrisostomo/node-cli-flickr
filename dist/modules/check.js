"use strict";var Check,Manifest,_,async,fs,mixin,path;_=require("lodash"),async=require("async"),fs=require("fs"),path=require("path"),Manifest=require("./manifest"),mixin=require("./mixin"),Check=function(){function n(){}return n.prototype.run=function(n,e){return function(i){return function(r){return async.series([i._checkDirectory(e),i._checkManifest(n,e),i._checkVideos(e)],r)}}(this)},n.prototype._checkDirectory=function(n){return function(e){var i;return mixin.write("blue","\nChecking directory..."),i=process.cwd()+"/"+n,fs.existsSync(i)?(mixin.write("green","\nChecking directory : done"),e(null,{})):(mixin.write("red","\nDirectory do not exist."),mixin.write("blue","\nCreating directory...."),fs.mkdir(""+i,"0777",function(n){return n&&mixin.write("green","\nError while creating directory!"),mixin.write("green","\nCreating directory : done"),e(null,{})}))}},n.prototype._checkManifest=function(n,e){return function(i){var r,t;return mixin.write("blue","\nChecking `.manifest.json`..."),r=process.cwd()+"/"+e,fs.existsSync(r+"/.manifest.json")?(mixin.write("green","\nChecking `.manifest.json` : done"),i(null,{})):(mixin.write("red","\n`.manifest.json` do not exist."),t=new Manifest,t.create(n,e,1)(i))}},n.prototype._checkVideos=function(n){return function(e){return mixin.write("blue","\nChecking videos..."),async.waterfall([function(e){var i,r;return mixin.write("blue","\nGetting video ids..."),r=[],i=process.cwd()+"/"+n,fs.readdir(i,function(n,i){return mixin.write("green","\nGetting video ids : done"),i.forEach(function(n){var e;return e=null!=n?n.match(/(\d+)/g):void 0,r=_.union(r,e)}),e(n,r)})},function(e,i){var r,t,o;return mixin.write("blue","\nUpdating status..."),r=[],t=e,o=process.cwd()+"/"+n+"/.manifest.json",o=require(o),null!=o&&o.forEach(function(n){return n.status="created",null!=t&&t.forEach(function(e){return n.id===parseInt(e)?n.status="completed":void 0}),r.push(n)}),mixin.write("green","\nUpdating status : done"),i(null,r)},function(e,i){var r,t;return mixin.write("blue","\nUpdating `.manifest.json`..."),t=e,r=process.cwd()+"/"+n+"/.manifest.json",fs.writeFile(r,JSON.stringify(t,null,4),function(n){return mixin.write("green","\nUpdating `.manifest.json` : done"),i(n,t)})}],function(n,i){var r,t;return t=i,r=_.filter(t,{status:"completed"}),mixin.write("green","\nChecking videos : done"),mixin.write("magenta","\n\nDownloaded Videos : "+(null!=r?r.length:void 0)+" of "+(null!=t?t.length:void 0)+"\n"),e(n,i)})}},n}(),module.exports=Check;