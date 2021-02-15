function add_shadow(){
    $(this).addClass('shadow-lg').css('cursor', 'pointer');
  }

function remove_shadow() {
    $(this).removeClass('shadow-lg');
  }

$(document).ready(function() {
 // executes when HTML-Document is loaded and DOM is ready

  $( ".home_pg_func_btns" ).hover(add_shadow, remove_shadow);
  $( ".home_pg_func_btns" ).click(add_shadow);
// document ready
});
