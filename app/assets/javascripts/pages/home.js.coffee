# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  count = 0
  unlock = true

  sourceClick = (event) ->
    tweet = $(this)
    tweet.fadeOut ()->
      $("#censor-wall dl").after event.currentTarget
      tweet.unbind()
      tweet.css("background-color", "")
      tweet.fadeIn()
      tweet.click censorClick

  censorClick = (event) ->
    tweet = $(this)
    tweet.unbind()
    $("#source-wall dl").after event.currentTarget
    tweet.click sourceClick

  refresh = (keyword) ->
    count++
    if count % 50 == 0 and unlock
      $('#myModal').modal()
      $("#password-error").html "Please enter"
      $("#password-error").css "color", ""


    $("#refresh").attr("class", "btn disabled")
    $("#refresh").html "Refreshing"
    $.ajax {
      url: "/api?q=#{keyword}"
      dataType: "json"
      success: (result) ->
        $("#refresh").attr("class", "btn btn-primary")
        $("#refresh").html "Refresh"
        $("#source-wall dl").html ""
        for tweet in result.results
          $("#source-wall dl").append "<div class=\"tweet\"><dt>#{tweet.from_user}</dt>\n<dd>#{tweet.text}</dd><hr /></div>"

        $('#source-wall .tweet').click sourceClick

        $('#source-wall .tweet').hover(
          ()-> $(this).css("background-color", "#DDFFDD"),
          ()-> $(this).css("background-color", "")
        )
    }

  $("#refresh").click( () ->
    keyword = $("#keyword")[0].value
    if not keyword
      alert "Keyword empty"
    else
      refresh(keyword)
  )

  auto = false
  $("#auto").click( () ->
    if auto
      auto = false
      $("#auto").attr "class", "btn btn-success"
      $("#auto").html "Start"
    else
      auto = true
      $("#auto").attr "class", "btn btn-danger"
      $("#auto").html "Stop"
      autoRefresh()
  )

  autoRefresh = () ->
    while auto
      keyword = $("#keyword")[0].value
      refresh(keyword)

  keyword = $("#keyword")[0].value
  if keyword
    refresh(keyword)

  $('#myModal').modal()

  $("#unlock").click () ->
    password = $("#password")[0].value
    $.ajax {
      url: "/unlock?password=#{password}"
      success: (result) ->
        if result == "true"
          unlock = false
          $('#myModal').modal("hide")
        else
          $("#password-error").html "Wrong Serial Numbers"
          $("#password-error").css "color", "red"
    }
