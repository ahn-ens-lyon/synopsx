function init(){
     $('*[data-url]').each(function(){
       var url = $(this).data('url')+'?pattern='+$(this).prop('tagName').toLowerCase();
       $(this).load(url);
       // alert(url);
      }); 
};