$(document).ready(function(){
  if ($("#analyze")[0].innerHTML.indexOf("✔") > -1) {
    $('#words').slideDown();
  };

  webSockets();

  $('#filepicker').on('submit', function(event){
    event.preventDefault();

    texts = $('#filepicker input[type=checkbox]:checked')
      .map(function(){
        return this.value
      }).get();

    if(texts.length != 0) {
      $.ajax({
        type: "POST",
        url: "/",
        data: 'texts=' + texts,
        success: markovReady(texts)
      })
    } else {
      alert("Try selecting one or more texts. Silly zander")
    }
  });

  function markovReady(texts) {
    $("#analyze")[0].innerHTML = "✔ Dictionary built from: " +
                                 texts.join(", ");
    $('#words').slideDown();
  };

  function webSockets() {
    var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);
    ws.onopen    = function()  {  };
    ws.onclose   = function()  {  };
    ws.onmessage = function(m) { showSuggestions(m.data); };

    $('#input').on('keyup', function(event){
      caretPosition = getCaretPosition(event.target);
      word = returnWord(event.target.value, caretPosition);
      ws.send(word);
    })
  };

  function showSuggestions(data) {
    var suggestions = JSON.parse(data)
    var container = $('#suggestions ul')
    container.empty()
    suggestions.forEach(function(sugg){
      var suggestionHtml = "<li>" +
                           sugg[0] +
                           " (" +
                           sugg[1] +
                           " occurences)</li>";
      container.append(suggestionHtml);
    })
  }

  function getCaretPosition(ctrl) {
    var CaretPos = 0;   // IE Support
    if (document.selection) {
      ctrl.focus();
      var Sel = document.selection.createRange();
      Sel.moveStart('character', -ctrl.value.length);
      CaretPos = Sel.text.length;
    }
    // Firefox support
    else if (ctrl.selectionStart || ctrl.selectionStart == '0')
      CaretPos = ctrl.selectionStart;
    return (CaretPos);
  }

  function returnWord(text, caretPos) {
    var index = text.indexOf(caretPos);
    var preText = text.substring(0, caretPos);
    if (preText.indexOf(" ") > 0) {
      var words = preText.split(" ");
      return words[words.length - 1]; //return last word
    }
    else {
      return preText;
    }
  }

});
