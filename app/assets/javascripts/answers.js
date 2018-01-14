$(document).on('turbolinks:load',function() {
  $('.answers').on('click','.edit-answer-link', function(e) {
    e.preventDefault();
    let editLink = $(this);
    let answerId=  editLink .data('answer-id');
    editLink .hide();
    let answer = $('#edit-answer-'+answerId);
    answer.show();

    
    $('.btn-save-updated-answer, .btn-cancel-edit-answer').on('click', function(e) {
      e.preventDefault();
      answer.hide();
      editLink.show();
    });
  });
});