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
      $("#mycourse-holder").html(data)
  false
  
$ ->
  $('.modal').on 'shown.bs.modal', ->
    $('form[data-validate]').enableClientSideValidations()
  $("#mycourse").on "change", ->           
    loadmycourse()
  loadmycourse()