# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@loadmycourse = () ->
  mycourse = $("#mycourse").val()
  location = "/showmycourse"
  if mycourse? && mycourse != ""
    mycoursearr = mycourse.split(',')
    location = "/showmycourse?course=#{mycoursearr[0]}&room=#{mycoursearr[1]}"
  #console.log(location)  
  $.get location, (data)->
      #console.log(data)
      mycourseobj = $("#mycourse-holder").html(data)
      mycourseobj.find(".emotion-radio-block input[type=radio]").on "click",->
        curemo = $(this).val()
        emoblock = $(this).closest(".emotion-radio-block")
        curcourse = emoblock.find("#emo_course_id").val()
        curroom = emoblock.find("#emo_room_id").val()
        #console.log(curemo)
        emoblock.toggleClass("ajax-waiting").removeClass("ajax-fail")
        $.ajax 
            url: "/addemotion"
            method: "post"
            dataType: "json"
            data: {
              emo: curemo,
              course: curcourse
              room: curroom
            }
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error);
              emoblock.toggleClass("ajax-fail")
            success: (response) ->
              emoblock.toggleClass("ajax-waiting")
              #console.log(response["results"])
  false
  
$ ->
  $('.modal').on 'shown.bs.modal', ->
    $('form[data-validate]').enableClientSideValidations()
  $("#mycourse").on "change", ->           
    loadmycourse()
  loadmycourse()