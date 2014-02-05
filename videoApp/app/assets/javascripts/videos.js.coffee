jQuery ->
  $("#upload-form").S3Uploader
    progress_bar_target: $(".js-progress-bars")
    allow_multiple_files: false
    click_submit_target: $("#submit-target")

$("#upload-form").bind 's3_uploads_start', (e) ->
  alert("Uploads have started")