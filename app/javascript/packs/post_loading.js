document.addEventListener("turbolinks:load", function () {
  $(function(){
    $('#post-submit-btn').on('click', function(){
      $('#post-submit-btn').html("<button class='btn btn-primary w-100'><span class='spinner-border spinner-border-sm mr-1' role='status' aria-hidden='true'></span>投稿中...</button>")
    });
  });
  $(function(){
    $('#post-edit-btn').on('click', function(){
      $('#post-edit-btn').html("<button class='btn btn-primary w-100'><span class='spinner-border spinner-border-sm mr-1' role='status' aria-hidden='true'></span>変更中...</button>")
    });
  });
});