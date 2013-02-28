function getNumPages() {
  $.ajax({
    url: '/' + content + '_num_pages?' + params,
    type: 'get',
    dataType: 'json',
    success: function(data) {
      numPages = data;
    }
  });
}
    
function appendNextPage() {
  $.ajax({
    url: '/' + content + '_feed?' + params + '&page=' + page,
    type: 'get',
    dataType: 'script',
    success: function() {
      loading = false;
    }
  });
}
  
function nearBottomOfPage() {
  return $(window).scrollTop() > $(document).height() - $(window).height() - 50;
}
 
function resetParams() {
  page = 1;
  num_pages = 0;
}
    
function feed() {
  getNumPages();
  appendNextPage();
    
  $(window).scroll(function(){
    if (page >= numPages || loading) {
      return;
    }

    if(nearBottomOfPage()) {
      loading=true;
      page++;
      appendNextPage();
    }
  });
}
