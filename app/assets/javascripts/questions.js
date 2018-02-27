
$(document).on('turbolinks:load',function() {
  $('.question').on('click','.edit-question-link', function(e) {
    e.preventDefault();
    let editLink = $(this);
    let questionId= editLink.data('question-id');
    editLink.hide();
    let question = $('#edit-question-'+questionId);
    question.show();

    $('.btn-cancel-edit-question').on('click', function(e) {
      e.preventDefault();
      question.hide();
      editLink.show();
    });
  });

 

  $('.question').on('click','.vote-for', function(e) {
    e.preventDefault();
    var parent = $(this).parent('.vote');
    var questionId = parent.data('id');
    ajaxRequest('POST','/questions/' + questionId + '/vote_for')
    .then(function(data){
       parent.find('.vote-score').text(data.score);
       toggleButtons(parent)
    })
  });

  $('.question').on('click','.vote-against', function(e) {
    e.preventDefault();
    var parent = $(this).parent('.vote');
    var questionId = parent.data('id');
    ajaxRequest('POST','/questions/' + questionId + '/vote_against')
    .then(function(data){
       parent.find('.vote-score').text(data.score);
       toggleButtons(parent)
    })
  });

  $('.question').on('click','.reset-vote', function(e) {
    e.preventDefault();
    var parent = $(this).parent('.vote');
    var questionId = parent.data('id');
    ajaxRequest('POST','/questions/' + questionId + '/reset_vote')
    .then(function(data){
       parent.find('.vote-score').text(data.score);
       toggleButtons(parent)
    })
  });
});