$(document).ready(function() { 
  var completer;
  completer = new GmapsCompleter({inputField: '#gmaps-input-address', errorField: '#gmaps-error'});
  completer.autoCompleteInit();
});