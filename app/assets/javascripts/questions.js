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
});