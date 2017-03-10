require( './Theme/styles/reset.css' );
require( './Theme/styles/main.css' );
require( './Theme/styles/story.css' );


// inject bundled Elm app
var Elm = require( './Main' );
var app = Elm.Main.fullscreen();

app.ports.loaded.send(true);
app.ports.getNewItemOffsetTop.subscribe(function() {
  requestAnimationFrame(function() {
    var offset = document.querySelector('.Storyline__Item:last-child').offsetTop;
    app.ports.readyToScroll.send(offset);
  });
});
