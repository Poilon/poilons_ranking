(function($) {
  $(document).ready(function() {
    $('.toggler').click(function (e) {
      $($(this).data('target')).toggle()
      e.preventDefault()
    })
  });
}) (jQuery);
