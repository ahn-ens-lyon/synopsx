function init(){
     $('*[data-url]').each(function(){
       var url = $(this).data('url')+'?pattern='+$(this).prop('tagName').toLowerCase();
       $node = $(this).load(url);
       $(this).replaceWith($node);
      });
      
      var menu = $('#navigation-menu');
      var menuToggle = $('#js-mobile-menu');
      var signUp = $('.sign-up');
      $(menuToggle).on('click', function(e) {
        e.preventDefault();
        menu.slideToggle(function(){
          if(menu.is(':hidden')) {
            menu.removeAttr('style');
          }
        });
      });

      // underline under the active nav item
      $(".nav .nav-link").click(function() {
        $(".nav .nav-link").each(function() {
          $(this).removeClass("active-nav-item");
      });
      $(this).addClass("active-nav-item");
      $(".nav .more").removeClass("active-nav-item");
    });
   
};