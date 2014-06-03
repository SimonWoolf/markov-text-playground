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

    $.ajax({
      type: "POST",
      url: "/",
      data: 'texts=' + texts,
      success: markovReady(texts)
    })
  });

  function markovReady(texts) {
    $("#analyze")[0].innerHTML = "✔ Dictionary built from: " +
                                 texts.join(", ");
    $('#words').slideDown();
  };

  function webSockets() {
    var show = function(el){
      return function(msg){
        el.innerHTML = msg + '<br />' + el.innerHTML;
      }
    }(document.getElementById('msgs'));

    var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);
    ws.onopen    = function()  { show('websocket opened'); };
    ws.onclose   = function()  { show('websocket closed'); }
    ws.onmessage = function(m) { show('websocket message: ' +  m.data); };

    $('#input').on('keyup', function(event){
      caretPosition = getCaretPosition(event.target);
      word = returnWord(event.target.value, caretPosition);
      ws.send(word);
    })
  };

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

  function AlertPrevWord() {
  }

});
