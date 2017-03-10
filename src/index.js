require( './Theme/styles/reset.css' );
require( './Theme/styles/main.css' );
require( './Theme/styles/story.css' );


// inject bundled Elm app
var Elm = require( './Main' );
var app = Elm.Main.fullscreen();

app.ports.loaded.send(true);
app.ports.prepScroll.subscribe(function() {
  requestAnimationFrame(function() {
    var offset = document.querySelector('.Storyline__Item:last-child').offsetTop;
    var scrollTop = document.querySelector('#scroll-container').scrollTop;
    app.ports.readyToScroll.send({offset: offset, scrollTop: scrollTop});
  });
});
