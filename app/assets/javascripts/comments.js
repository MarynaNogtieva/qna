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

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      var questionId = $('div.question').data('id');
      if(questionId){
        this.perform('follow',{ id: questionId });
        console.log('connected comments');
      }
    },
    received: function(data) {
      var current_user_id = gon.current_user_id 
      console.log(data);
      if (data['commentable_type'] === 'question') {
        
        $('.question-wrap').find('.all-comments').append(JST["templates/comment"](data)); 
      }
      else if (data['commentable_type'] === 'answer'){
        $('div#answer-id-' + data['commentable_id']).find('.all-comments').append(JST["templates/comment"](data)); 
      }
    }
  });
});