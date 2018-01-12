$(document).on('turbolinks:load',function() {
  $('.answers').on('click','.edit-answer-link', function(e) {
    e.preventDefault();
    let answerId= $(this).data('answer-id');
    console.log(answerId);
    let answer = $('#edit-answer-'+answerId);
    answer.show();
  });
  $('.btn-save-updated-answer').on('click', function(e) {
    answer.hide();
  });
});