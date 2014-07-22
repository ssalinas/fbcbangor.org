$(function() {
    var window_height = $(window).height(),
       content_height = window_height - 200;
    $('.facebookfeed').height(content_height);
    $('.leftsidecol').height(content_height);
});

$( window ).resize(function() {
    var window_height = $(window).height(),
        content_height = window_height - 200;
    $('.facebookfeed').height(content_height);
    $('.leftsidecol').height(content_height);
});
