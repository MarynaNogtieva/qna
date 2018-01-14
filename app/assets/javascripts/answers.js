$(document).on('turbolinks:load',function() {
  $('.answers').on('click','.edit-answer-link', function(e) {
    e.preventDefault();
    let answerId= $(this).data('answer-id');
    $(this).hide();
    let answer = $('#edit-answer-'+answerId);
    answer.show();
    
  });
  $('.btn-save-updated-answer, .btn-cancel-edit-answer').on('click', function(e) {
    e.preventDefault();
    answer.hide();
    $(this).show();
  });
});