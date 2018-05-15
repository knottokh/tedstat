# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@loadapproved = () ->
  course = $("#course").val()
  room = $("#room").val()
  location = "/showapproved?course=#{course}&room=#{room}"
  $.get location, (data)->
      #console.log(data)
      $("#approved-holder").html(data)
      $(".input-type-number").on "change", ->           
        eml = this
        $(this).removeClass "ajax-fail"
        $(this).addClass "ajax-waiting"
        taskid = $(this).closest("td").data("id")
        userid = $(this).closest("tr").data("id")
        input_i = parseInt($(this).val(),10)
        if !isNaN(input_i)
          #console.log("#{taskid} - #{userid} -- #{input_i}")
          $.ajax 
            url: "/addusertask"
            method: "post"
            dataType: "json"
            data: {
              user_id: userid,
              task_id: taskid,
              score: input_i
            }
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error)
              $(eml).removeClass "ajax-waiting"
              $(eml).addClass "ajax-fail"
            success: (response) ->
              saveresult = response["results"]
              $(eml).removeClass "ajax-waiting"
              if !saveresult
                $(eml).addClass "ajax-fail"

  false
@loadpending = () ->
  course = $("#course").val()
  room = $("#room").val()

  location = "/ajaxremotes/showpending?course=#{course}&room=#{room}"
  #console.log(location)
  $.get location, (data)->
      #console.log(data)
      $("#pending-holder").html(data)
      $(".approverequest").on "click", -> 
        rid = $(this).data("id")
        $.ajax 
          url: "/approve"
          method: "post"
          dataType: "json"
          data: {
            id: rid
          }
          error: (xhr, status, error) ->
            console.error('AJAX Error: ' + status + error);
          success: (response) ->
            console.log(response["results"])
            loadpending()
            loadapproved()
      $(".rejectrequest").on "click", -> 
        rid = $(this).data("id")
        rcon = confirm('Are you sure to reject?')
        if rcon
          $.ajax 
            url: "/reject"
            method: "post"
            dataType: "json"
            data: {
              id: rid
            }
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error);
            success: (response) ->
              console.log(response["results"])
              loadpending()
  false  
@updateyear = () ->
  oyear = $("#year").val()
  ocourse = $("#course").val()
  $.ajax 
      url: "/managecourse"
      method: "GET"
      dataType: "json"
      data: {
          year: oyear,
      }
      error: (xhr, status, error) ->
        console.error('AJAX Error: ' + status + error);
      success: (response) ->
        #console.log(response)
        years = response["years"]
        if years.length > 0
          $("#year").empty()
          $("#year").removeAttr "disabled"
          $("#year").append '<option>Select courses</option>'
          for yy in years
            $("#year").append '<option value="' + yy["couse_year"] + '">' + yy["couse_year"] + '</option>'
        $("#year").val(oyear)
        courses = response["courses"]
        if courses.length > 0
          $("#course").empty()
          $("#course").removeAttr "disabled"
          $("#course").append '<option>Select courses</option>'
          for cc in courses
            $("#course").append '<option value="' + cc["id"] + '">' + cc["couse_name"] + '</option>'    
        $("#course").val(ocourse)    
@updateroom = () ->
  ocourse = $("#course").val()
  oroom = $("#room").val()
  $.ajax 
      url: "/managecourse"
      method: "GET"
      dataType: "json"
      data: {course: ocourse}
      error: (xhr, status, error) ->
        console.error('AJAX Error: ' + status + error);
      success: (response) ->
        #console.log(response)
        rooms = response["rooms"]
        if rooms.length > 0
          $("#room").empty()
          $("#room").removeAttr "disabled"
          $("#room").append '<option>Select courses</option>'
          for rr in rooms
            $("#room").append '<option value="' + rr["id"] + '">' + rr["room_name"] + '</option>'
        $("#room").val(oroom)
$ ->
  $('.modal').on 'shown.bs.modal', ->
    $('form[data-validate]').enableClientSideValidations()
  $("#from-select-room").on 'ajax:success',
     (event, data, status, xhr)->
        console.log("success")
      
  $("#year").on "change", ->    
    year = $(this).val()
    #console.log(year)
    $("#course").empty().attr("disabled","disabled")
    $("#room").empty().attr("disabled","disabled")
    $("#findcourse").attr("disabled","disabled")
    $.ajax 
      url: "/managecourse"
      method: "GET"
      dataType: "json"
      data: {year: year}
      error: (xhr, status, error) ->
        console.error('AJAX Error: ' + status + error);
      success: (response) ->
        #console.log(response)
        courses = response["courses"]
        if courses.length > 0
          $("#course").empty()
          $("#course").removeAttr "disabled"
          $("#course").append '<option>Select courses</option>'
          for course in courses
            $("#course").append '<option value="' + course["id"] + '">' + course["couse_name"] + '</option>'
  $("#course").on "change", ->    
      course = $(this).val()
      course_i = parseInt(course,10)
      if !isNaN(course_i)
        $("#edit_course").removeClass "hidden"
      else
        $("#edit_course").addClass "hidden"
        
      $("#room").empty().attr("disabled","disabled")
      $("#findcourse").attr("disabled","disabled")
      $.ajax 
        url: "/managecourse"
        method: "GET"
        dataType: "json"
        data: {course: course}
        error: (xhr, status, error) ->
          console.error('AJAX Error: ' + status + error);
        success: (response) ->
          #console.log(response)
          rooms = response["rooms"]
          if rooms.length > 0
            $("#room").empty()
            $("#room").removeAttr "disabled"
            $("#room").append '<option>Select rooms</option>'
            for room in rooms
              $("#room").append '<option value="' + room["id"] + '">' + room["room_name"] + '</option>'
  
  $("#room").on "change", ->           
    course = $(this).val()
    room_i = parseInt(course,10)
    if !isNaN(room_i)
      $("#edit_room").removeClass "hidden"
    else
      $("#edit_room").addClass "hidden"
    #console.log(course)
    if !course.nil? and !course.empty? and course != "Select rooms" and course != ""
       $("#findcourse").removeAttr "disabled"
    else
       $("#findcourse").attr("disabled","disabled")
       
  #load approve
  loadapproved()
  loadpending()