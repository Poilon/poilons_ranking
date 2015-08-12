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

$(function () {
  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15 // Creates a dropdown of 15 years to control year
  });
})
