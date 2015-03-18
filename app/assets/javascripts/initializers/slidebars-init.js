(function($) {
  $(document).ready(function() {
    $(".button-collapse").sideNav({edge: 'right'});
    $('.parallax').parallax();
    $.cloudinary.responsive();
  });
}) (jQuery);

$(document).on('ready page:change', function () {
  Waves.displayEffect()
})
