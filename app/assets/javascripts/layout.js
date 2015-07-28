$(document).ready(function () {
    $(".button-collapse").sideNav();

    $('.tab').on('click', function(){
        $(window).resize();
    });
});