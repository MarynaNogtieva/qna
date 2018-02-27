
$(document).on('turbolinks:load',function() {
  $('.answers').on('click','.edit-answer-link', function(e) {
    e.preventDefault();
    var editLink = $(this);
    var answerId =  editLink.data('answerId');
    editLink .hide();
    var answer = $('#edit_answer_'+answerId);
    answer.show();

    
    $('.btn-cancel-edit-answer').on('click', function(e) {
      e.preventDefault();
      answer.hide();
      editLink.show();
    });
  });

  $('.answers').on('click','.vote-for', function(e) {
    e.preventDefault();
    var parent = $(this).parent('.vote');
    var answerId = parent.data('id');
    ajaxRequest('POST','/answers/' + answerId + '/vote_for')
    .then(function(data){
       parent.find('.vote-score').text(data.score);
       toggleButtons(parent)
    })
  });

  $('.answers').on('click','.vote-against', function(e) {
    e.preventDefault();
    var parent = $(this).parent('.vote');
    var answerId = parent.data('id');
    ajaxRequest('POST','/answers/' + answerId + '/vote_against')
    .then(function(data){
       parent.find('.vote-score').text(data.score);
       toggleButtons(parent)
    })
  });

  $('.answers').on('click','.reset-vote', function(e) {
    e.preventDefault();
    var parent = $(this).parent('.vote');
    var answerId = parent.data('id');
    ajaxRequest('POST','/answers/' + answerId + '/reset_vote')
    .then(function(data){
       parent.find('.vote-score').text(data.score);
       toggleButtons(parent)
    })
  });
});