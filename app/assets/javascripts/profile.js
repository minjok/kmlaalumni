$(document).ready(function(){
    $('.careernote_button').hide();		  
  });

jQuery(function($) {
  $("#employments_container").mouseenter(function() {
    // make a POST call and replace the content
     $('.careernote_button').show("slow");
  });
  $("#employments_container").mouseleave(function() {
    // make a POST call and replace the content
     $('.careernote_button').hide("slow");
  });
  
});
