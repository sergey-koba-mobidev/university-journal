$(document).ready(function () {
    $(".button-collapse").sideNav();

    $('.tab').on('click', function(){
        $(window).resize();
    });
    $('select').material_select();
});