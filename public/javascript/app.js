$(document).ready(function(){
  $('#filepicker').on('submit', function(event){
    event.preventDefault();

    texts = $('#filepicker input[type=checkbox]:checked')
      .map(function(){
        return this.value
      }).get();

    $.ajax({
      type: "POST",
      url: "/",
      data: 'texts=' + texts
    })
  });

});
