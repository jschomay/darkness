require( './Theme/styles/reset.css' );
require( './Theme/styles/main.css' );
require( './Theme/styles/story.css' );


// inject bundled Elm app
var Elm = require( './Main' );
var app = Elm.Main.fullscreen();

app.ports.loaded.send(true);
