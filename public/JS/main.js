jQuery(function ($) {
    if ( $('#home_pic') ) {
        $(window).scroll(function() {
            if( $(window).scrollTop() > 20 ) {
                $('#home_pic').animate(
                    {
                        'top': -820,
                        'margin-top': -520
                    },
                    700,
                    function(){
                        $('#home_pic').css('display', 'none');
                    }
                );
            }
        });
    }

    $('.blog_nav li').tooltipsy();
});