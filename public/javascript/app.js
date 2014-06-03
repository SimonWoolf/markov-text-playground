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

  $("#gimme").on('click', function(event) {
    $.ajax({
      type: "GET",
      url: "/randomword",
      success: function(response){
        insertAtCaret(response);
        // focus input so that suggestions update
        $('#input').focus();
      }
    })
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

    $('#input').on('keyup focus', function(event){
      caretPosition = getCaretPosition();
      word = returnWord(event.target.value, caretPosition);
      console.log(word);
      ws.send(word);
    })
  };

  function showSuggestions(data) {
    var suggestions = JSON.parse(data)
    var container = $('#suggestions ul')
    container.empty()
    suggestions.forEach(function(sugg){
      var suggestionHtml = "<li><button class='suggestion' value='" +
                           sugg[0] + "'>" + sugg[0] +
                           "</button> (" +
                           sugg[1] +
                           " occurences)</li>";
      container.append(suggestionHtml);
    });
    $('button.suggestion').on('click', function(){
      insertAtCaret(this.value);
    })
  }

  function insertAtCaret(word) {
    var textAreaTxt = jQuery("#input").val();
    var caretPos = getCaretPosition()
    $("#input").val(textAreaTxt.substring(0, caretPos) + " " +
                    word + textAreaTxt.substring(caretPos))
               .focus();
  }

  function getCaretPosition() {
    ctrl = $('#input')[0]
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
    var preText = text.substring(0, caretPos);
    if (preText.indexOf(" ") > -1 ) {
      var words = preText.split(/\s+/)
                         .filter(function(w){
                           return w.length > 0;
                         });
      return words[words.length - 1]; //return last word
    }
    else {
      return preText;
    }
  }

});
