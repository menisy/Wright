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
//= require bootstrap
//= require jquery-fileupload/basic
//= require_tree .


$(window).load(function(){
  dropFlash();
});
$(document).ready( function(){
  counter = -1;
  words = [];

  $('#click-upload').click(function(e){
    e.preventDefault();
    $('#file-upload').click();
  });

  $('input[id=file-upload]').change(function() {
    var path = $(this).val();
    path = path.substring(path.lastIndexOf('\\')+1)
    $('span.filename').html(path);
    });

  $('.start').on('click', function(e){
    e.preventDefault();
    $(this).fadeOut(200);
    $(".one").animate({opacity: 1.0, left: +100}, 600).animate({opacity: 0.0, left: +100}, 400).queue(function(){
      $(".two").animate({opacity: 1.0, left: -100}, 600).animate({opacity: 0.0, left: -100}, 400).queue(function(){
        $(".three").animate({opacity: 1.0, left: +100}, 600).animate({opacity: 0.0, left: +100}, 400).queue(function(){
          $(".go").animate({opacity: 1.0, zoom: 2}, 400).animate({opacity: 0.0, zoom: 4}, 400).queue(function(){
            $('#input').focus();
            start(counter);
          });
        });
      });
    });
  });

  $( "#input" ).keypress(function( event ) {
    if ( event.which == 13 ) {
       event.preventDefault();
       clearAndMove();
    }
  });
  //$('.upper-box').append($('.image-holder img'));
});


function start(){
  y = 0;
  gameOver = false;
  max = $('.image-holder').children().length;
  moveNewWord();
}

function moveWord(){
  if(y + 200 > $('.upper-box').height()){
    $('#input').addClass('shadow');
  }
  if(y + 30 > $('.upper-box').height()){
    //catchWord();
    clearAndMove();
  }
  y = y + 8 - currentFactor;
  currentWord.css('top',y+'px');
}

function catchWord(){
  var wrd = $('#input').val();
  words = words.concat(wrd);
  console.log(wrd)
  console.log(words)
}

function clearAndMove(){
  if(gameOver)
    return false;
  catchWord();
  $('#input').val('');
  $('#input').removeClass('shadow');
  if(currentWord.length){
    cw = currentWord.remove();
    $('.image-holder').append(cw);
  }
  clearTimeout(animation);
  moveNewWord();
}
function endGame(){
  gameOver = true;
  $('#input').removeClass('shadow');
  fin = [];
  for(var i=0; i < max; i++){
    wt = $('img#'+i);
    wr = {};
    console.log(wt);
    wr.id = $(wt).attr('name');
    wr.guess = words[i];
    fin = fin.concat(wr);
  }
  console.log(fin);
}
function moveNewWord(){
  y = 0;
  counter = counter + 1;
  console.log('max', max)
  console.log('counter', counter)
  if(counter == max){
    endGame();
    return false;
  }
  currentWord = $('.image-holder img#'+counter).remove();
  currentFactor = currentWord.width() * 0.3;
  $('.upper-box').append(currentWord);
  x = Math.random() * 400;
  currentWord.css('left', x+'px');
  currentWord.css('top','-20px');
  animation = setInterval(function(){moveWord()}, 100);
}

  function addFlash(cls, msg){
    var flash = '<div class="alert fade in alert-'+cls+'"><button class="close" data-dismiss="alert">×</button>'+msg+'</div>'
    $('#main-container').prepend(flash);
    dropFlash();
  }
  function dropFlash(){
    $('.alert').animate({top: 35}, 800);
  }