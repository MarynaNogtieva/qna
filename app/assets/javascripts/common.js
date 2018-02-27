function ajaxRequest(method, url, data) {
  var deferred = $.ajax({
    url: url,
    dataType: 'json',
    contentType: 'application/json; charset=UTF-8',
    type: method,
    data: data ? JSON.stringify(data) : null
  })
  .then(onSuccess, onFail);

  return deferred.promise();
}

function onSuccess(data){
  return data;
}

function onFail(err){
  return err
}

function toggleButtons(parent){
  parent.find('.vote-for-btn').toggleClass('hide');
  parent.find('.vote-against-btn').toggleClass('hide');
  parent.find('.reset-vote-btn').toggleClass('hide');
}