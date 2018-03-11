$(document).on('turbolinks:load',function() {
  $('form.new_comment').submit(function(e) {
    e.preventDefault();

    var parent = $(this).parents('.comments');
    var commentableId = parent.data('id');
    var url = $(this).attr('action');
    var bodyText = $(this).find('#comment_body')
    var dataToSubmit = { body: bodyText.val() };
  
    
    ajaxRequest('POST', url, dataToSubmit )
    .then(function(data){
    
      parent.find('.all-comments').append('<div>'+ 
      '<p.comment-body>' + data.body +'</p>'+
      '<p.user-email>' + data.user +'</p>'+
      '<p.comment-date>' + data.date +'</p>'+
       '</div>')
       bodyText.val('');
    });

    return false;
  });
});