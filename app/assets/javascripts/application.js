// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .


$(document).ready( function(){
  counter = -1;
  $('.start').click(function(){
    $(this).fadeOut(200);
    $('#input').focus();
    start(counter);
  });

  $( "#input" ).keypress(function( event ) {
    if ( event.which == 13 ) {
       event.preventDefault();
       $(this).val('');
       clearAndMove();
    }
  });
  //$('.upper-box').append($('.image-holder img'));
});


function start(){
  y = 0;
  moveNewWord();
}

function moveWord(){
  y = y + 7;
  currentWord.css('top',y+'px');
  if(y > $('.upper-box').height()){
    clearAndMove();
  }
}

function clearAndMove(){
  currentWord.remove();
  clearTimeout(animation);
  moveNewWord();
}
function moveNewWord(){
  y = 0;
  counter = counter + 1;
  currentWord = $('.image-holder img#'+counter).remove();
  $('.upper-box').append(currentWord);
  x = Math.random() * 400;
  currentWord.css('left', x+'px');
  currentWord.css('top','-20px');
  animation = setInterval(function(){moveWord()}, 100);
}