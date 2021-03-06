# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@loadapproved = () ->
  course = $("#course").val()
  room = $("#room").val()
  location = "/showapproved?course=#{course}&room=#{room}"
  if course != "" and room != ""
    $("#approved-holder").html($("#spinter-holder").html())
  $.get location, (data)->
      #console.log(data)
      $("#approved-holder").html(data)
      $(".input-number").on "change", ->
         eml = this   
         input_i = parseFloat($(this).val(),10)
         if isNaN(input_i)
            $(this).val("")
         else
           $(this).removeClass("ajax-fail")
           $(this).addClass "ajax-waiting"
           scourseid = $(this).closest("td").data("id")
           $.ajax 
            url: "/updateorder"
            method: "post"
            dataType: "json"
            data: {
              scourseid:scourseid,
              order: input_i
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
      $(".input-type-number").on "change", ->           
        eml = this
        $(this).removeClass("ajax-fail").next().text("")
        $(this).addClass "ajax-waiting"
        taskid = $(this).closest("td").data("id")
        userid = $(this).closest("tr").data("id")
        input_i = parseInt($(this).val(),10)
        maxscourejson = $(this).data("max")
        maxscore = parseInt(maxscourejson.score,10)
          
        if !isNaN(input_i) and !isNaN(maxscore)
          if  input_i > maxscore
              input_i = maxscore
              $(this).val(maxscore)
          #console.log("#{taskid} - #{userid} -- #{input_i}")
          $.ajax 
            url: "/updatescore"
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
              #console.log(saveresult.saved)
              $(eml).removeClass "ajax-waiting"
              if saveresult.saved
                closesttr = $(eml).closest("tr")
                closesttr.find("span[data-mytype=mypoint]").text(saveresult.score)
                closesttr.find("span[data-mytype=mygrade]").text(saveresult.grade)
              else
                $(eml).addClass "ajax-fail"
        else
          $(this).addClass("ajax-fail").next().text("ตรวจสอบตัวเลขหรือคะแนนเต็ม")
      $(".point-attr-all").on "click", ->           
        eml = this
        prrtresult = $(this).data("pttr")
        confirmmsg = "Are you sure to Select All?"
        if prrtresult == "false" || prrtresult == false 
          confirmmsg = "Are you sure to Deselect All?"
        r = confirm(confirmmsg)
        if r
          $("#approved-holder").prepend($("#spinter-holder").html())
          $(this).removeClass "ajax-fail"
          $(this).addClass "ajax-waiting"
          courseid = $("#course").val()
          roomid = $("#room").val()
          $.ajax 
              url: "/updatepointall"
              method: "post"
              dataType: "json"
              data: {
                pttr_select: prrtresult,
                course_id: courseid,
                room_id: roomid
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
                else
                  loadapproved()
      $(".input-type-textordropdown").on "change", ->           
        eml = this
        $(this).removeClass "ajax-fail"
        $(this).addClass "ajax-waiting"
        taskid = $(this).closest("td").data("id")
        userid = $(this).closest("tr").data("id")
        input_s = $(this).val()
        attr_tosave = $(this).data("saveto")
        datatoajax = {
                  user_id: userid,
                  task_id: taskid
        }
        datatoajax[attr_tosave] = input_s
        $.ajax 
            url: "/updatetext"
            method: "post"
            dataType: "json"
            data: datatoajax
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error)
              $(eml).removeClass "ajax-waiting"
              $(eml).addClass "ajax-fail"
            success: (response) ->
              saveresult = response["results"]
              $(eml).removeClass "ajax-waiting"
              if !saveresult
                $(eml).addClass "ajax-fail"
      $(".input-type-checkboxattr").on "change", ->           
        eml = this
        $(this).closest(".checkboxattr-block").removeClass("ajax-fail").next().text("")
        $(this).closest(".checkboxattr-block").addClass "ajax-waiting"
        taskid = $(this).closest("tr").find("td[data-task-id]:first").data("id")
        userid = $(this).closest("tr").data("id")
        input_s = $(this).is(':checked')
        attr_tosave = $(this).data("saveto")
        datatoajax = {
                  user_id: userid,
                  task_id: taskid
        }
        datatoajax[attr_tosave] = input_s
        #console.log(datatoajax)
        $.ajax 
            url: "/updatepoint"
            method: "post"
            dataType: "json"
            data: datatoajax
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error)
              $(eml).closest(".checkboxattr-block").removeClass "ajax-waiting"
              $(eml).closest(".checkboxattr-block").addClass "ajax-fail"
            success: (response) ->
              saveresult = response["results"]
              #console.log(saveresult)
              $(eml).closest(".checkboxattr-block").removeClass "ajax-waiting"
              if saveresult.saved
                closesttr = $(eml).closest("tr")
                closesttr.find("span[data-mytype=mypoint]").text(saveresult.score)
                closesttr.find("span[data-mytype=mygrade]").text(saveresult.grade)
              else
                $(eml).closest(".checkboxattr-block").addClass "ajax-fail"
      $(".input-type-checklist").on "click", ->           
        eml = this
        $(this).parent().removeClass "ajax-fail"
        $(this).parent().addClass "ajax-waiting"
        taskid = $(this).closest("td").data("id")
        userid = $(this).closest("tr").data("id")
        input_s = []
        $(this).parent().find(".checklistblock").each (index, element) =>
          namechoice = $(element).find("input[type=radio]:first").attr("name")
          cvalue = $("input:radio[name='"+namechoice+"']:checked").val()
          if cvalue?
            input_s.push(cvalue)
        attr_tosave = $(this).data("saveto")
        datatoajax = {
                  user_id: userid,
                  task_id: taskid
        }
        datatoajax[attr_tosave] = input_s.join(',')
        $.ajax 
            url: "/updatetext"
            method: "post"
            dataType: "json"
            data: datatoajax
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error)
              $(eml).parent().removeClass "ajax-waiting"
              $(eml).parent().addClass "ajax-fail"
            success: (response) ->
              saveresult = response["results"]
              $(eml).parent().removeClass "ajax-waiting"
              if !saveresult
                $(eml).parent().addClass "ajax-fail"   
  false
@loadpending = () ->
  course = $("#course").val()
  room = $("#room").val()

  location = "/ajaxremotes/showpending?course=#{course}&room=#{room}"
  if course != "" and room != ""
    $("#pending-holder").html($("#spinter-holder").html())
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
      $(".approverequest-all").on "click", -> 
        r = confirm("Are you sure to Approve All?")
        if r
          $("#pending-holder").prepend($("#spinter-holder").html())
          courseid = $("#course").val()
          roomid = $("#room").val()
          $.ajax 
            url: "/approveall"
            method: "post"
            dataType: "json"
            data: {
                course_id: courseid,
                room_id: roomid
            }
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error);
            success: (response) ->
              saveresult = response["results"]
              console.log(saveresult)
              if saveresult
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
@loadshowgraph = () ->
  course = $("#course").val()
  room = $("#room").val()
  location = "/showgraph?course=#{course}&room=#{room}"
  if course != "" and room != ""
    $("#graph-holder").html($("#spinter-holder").html())
  $.get location, (data)->
      #console.log(data)
      $("#graph-holder").html(data)
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
  
  roomcheck = $("#room").val()
  if roomcheck? and !roomcheck.nil? and !roomcheck.empty? and roomcheck != "Select rooms" and roomcheck != ""
       $("#findcourse").removeAttr "disabled"
  #load approve
  if $("#teacher-index-container").data("currentpath") == "active"
    loadshowgraph()
  if $("#teacher-manage-container").data("currentpath") == "active"  
    loadapproved()
    loadpending()