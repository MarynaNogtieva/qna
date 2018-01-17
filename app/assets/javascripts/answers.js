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
});