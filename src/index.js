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
    var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
    app.ports.readyToScroll.send({offset: offset, scrollTop: scrollTop});
  });
});

app.ports.scrollPage.subscribe(function(offset) {
  // hack to make page scrolling work in both Firefox and other browsers
  document.querySelector("html").scrollTop = offset;
  document.querySelector("body").scrollTop = offset;
});

window.onscroll = function() {
  var scrollTop = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop;
  app.ports.onScroll.send(scrollTop);
};
