$(document).on('turbolinks:load',function() {
  $('form#new_comment').submit(function(e) {
    e.preventDefault();
    alert("HI");
    var parent = $(this).parent('.comments');
    var commentableId = parent.data('id');
    var url = $(this).attr('action');
    var dataToSubmit = { body: $('#comment_body').val() };
    ajaxRequest('POST', url, dataToSubmit )
    .then(function(data){
      parent.find('.all-comments').append('<div>'+ 
      '<p.comment-body>' + data.body +'</p>'+
      '<p.user-email>' + data.user +'</p>'+
      '<p.comment-date>' + data.date +'</p>'+
       '</div>')
      $('#comment_body').val('');
    });

    return false;
  });
});