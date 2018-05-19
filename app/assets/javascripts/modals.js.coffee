@calculatewarningtext = (input,isremove) ->
            isremove = isremove || false
            childscore  = $(input).closest(".child-score .content")
            warningdiv = $(input).closest(".child-score").find(".message")
            if !isremove
              valint = parseFloat($(input).val(),10)
              #console.log(valint)
              if isNaN(valint)
                $(input).val("")
            else
              $(input).closest(".percent_input_block").remove()   
            
            sumscroll = 0;
            childscore.find("input").each (index, element) =>
              childvalint = parseFloat($(element).val(),10)
              if !isNaN(childvalint)
                sumscroll += childvalint
            
            diff = 100 - sumscroll
            #console.log(diff)
            
            warningdiv.removeClass("text-danger").removeClass("text-warning")
            if diff > 0 and diff != 100
              warningdiv.text("เหลือเปอร์เซ็นต์ที่ต้องใช้ : "+diff).addClass("text-warning")
            else if diff < 0   
              warningdiv.text("เปอร์เซ็นต์เกินไปแล้ว : "+diff).addClass("text-danger")
            else
              warningdiv.text("") 
@setremoveroomtaskevent = (input) ->
    input.on 'click' ,->
      thisid  = $(this).parent().find("input").data("id")
      btncheck = $(this).closest(".child-score ").find(".selecttask[data-id="+thisid+"]")
      if btncheck.length > 0
        btncheck.removeClass("disabled btn-secondary").addClass("btn-primary")
      calculatewarningtext($(this).parent().find("input"),true)   
       
@setroomtaskevent = (input) ->
    input.on 'change',->
        calculatewarningtext(this)    
@setbuttonclick = (modelobj ) ->
      modelobj.find(".newOtherText1").on 'click',->
          newtmp = $(this).closest(".templateBlock").find(".templateText1").html()
          $(this).closest(".templateBlock").find(".showOtherText1").append(newtmp)
      modelobj.find(".newOtherText2").on 'click',->
          newtmp = $(this).closest(".templateBlock").find(".templateText2").html()
          $(this).closest(".templateBlock").find(".showOtherText2").append(newtmp)  
      modelobj.find(".task_can_select a.selecttask").on 'click',->
          $(this).removeClass("btn-primary").addClass("disabled btn-secondary")
          scorblock = $(this).closest(".scoreblock")
          childblock = $(this).closest(".percent_block").find(".child-score .content")
          warningdiv = $(this).closest(".percent_block").find(".message")
          fqtmp = $(scorblock.find(".templatePercent").html())
          fqtmp.find("lable").text($(this).data("task-name"))
          fqtmp.find("input").attr("data-id",$(this).data("id"))
          setroomtaskevent(fqtmp.find("input"))
          setremoveroomtaskevent(fqtmp.find(".delete-score-task"))
          childblock.append fqtmp
      modelobj.find("#ratio_grade_text").on 'change',->
          $(".gradeblock").empty()
          valgrade = parseInt($(this).val(),10)
          gradetext = []
          greadnumber = []
          
          if valgrade ==1 or valgrade == 3
            greadnumber = [100,80,70,60,50,0]
            if valgrade == 1
              gradetext = ["A","B","C","D","F"]
            else
              gradetext = [4,3,2,1,0]
            #gradetext = (valgrade == 1)? ["A","B","C","D","F"] : [4,3,2,1,0]
          else if valgrade ==2 or valgrade == 4
            greadnumber = [100,85,80,75,70,65,60,50,0]
            if valgrade == 2
              gradetext = ["A","B+","B","C+","C","D+","D","F"] 
            else
              gradetext = [7,6,5,4,3,2,1,0]
            #gradetext = (valgrade == 1)? ["A","B+","B","C+","C","D+","D","F"] : [7,6,5,4,3,2,1,0]

          countgrade = gradetext.length
          #console.log(countgrade)
          
          parentblock = $(this).closest(".gradezone")
          gradeblock = parentblock.find(".gradeblock")
          
          for i in [0...countgrade]   
            fqtmp = $(parentblock.find(".gradboxTemplate").html())
            leftnum = greadnumber[i+1]
            leftoper = "<="
            gtext = gradetext[i]
            rightoper = "<"
            rightnum = greadnumber[i]
            if i==0
              rightoper  = "<="
            fqtmp.find(".num-left input").val(leftnum).attr("data-index",i+1)
            fqtmp.find(".oper-left").text(leftoper)
            fqtmp.find(".grade-text input").val(gtext)
            fqtmp.find(".oper-right").text(rightoper)
            fqtmp.find(".num-right input").val(rightnum).attr("data-index",i)
            
            gradeblock.append fqtmp
          
          gradeblock.find("input[data-index]").on 'change',->
             currentval = $(this).val()
             dataindex = $(this).data("index")
             $(this).closest(".gradeblock").find("input[data-index="+dataindex+"]").val(currentval)
             
      modelobj.find(".random-mypin").on "click", ->    
          inputelm = $(this).closest(".form-group").find("input")
          $.ajax 
            url: "/genmypin"
            method: "GET"
            dataType: "json"
            error: (xhr, status, error) ->
              console.error('AJAX Error: ' + status + error);
            success: (response) ->
              inputelm.val(response.results)
      modelobj.find("#task_task_behavior").on 'change',->        
          settaskbehaviorextra($(this).closest(".form-group"))
          
      modelobj.find("#task_task_assessment").on 'change',->
          curval = $(this).val()
          devgourp = $(this).closest(".form-group")
          devgourp.find(".task_assignment_other_input").val("")
          if curval == "อื่นๆ"
            devgourp.find(".task_assignment_other").removeClass("hidden")
            assignotherval = modelobj.find("#task_task_assignment_other").val()
            if assignotherval != ""
              devgourp.find(".task_assignment_other_input").val(assignotherval)
          else
            devgourp.find(".task_assignment_other").addClass("hidden")
            
      modelobj.find(".input-type-number").on "change", ->           
              eml = this
              $(this).removeClass "ajax-fail"
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
                    $(eml).removeClass "ajax-waiting"
                    if !saveresult
                      $(eml).addClass "ajax-fail"
              else
                $(this).addClass("ajax-fail").next().text("ตรวจสอบตัวเลขหรือคะแนนเต็ม")
          
      modelobj.find(".input-type-textordropdown").on "change", ->           
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
                    
@settaskfeedback = (modelobj ) ->
      #Task feedback
      ttf = $("#task_task_feedback").val()
      try
        jsonttf = JSON.parse(ttf)
        #console.log(jsonttf)
        #quantity 
        pfq = modelobj.find(".feedback_quality").find(".templateBlock")
        for ai in jsonttf.quality
          fqtmp = $(pfq.find(".templateText2").html())
          fqtmp.find(".s1").val(ai.score)
          fqtmp.find(".s2").val(ai.text)
          pfq.find(".showOtherText2").append fqtmp
        #advantages 
        pfq = modelobj.find(".feedback_advan").find(".templateBlock")
        for aa in jsonttf.advantages
          fqtmp = $(pfq.find(".templateText1").html())
          fqtmp.find(".s1").val(aa)
          pfq.find(".showOtherText1").append fqtmp  
        #disadvantages 
        pfq = modelobj.find(".feedback_disad").find(".templateBlock")
        for ad in jsonttf.disadvantages
          fqtmp = $(pfq.find(".templateText1").html())
          fqtmp.find(".s1").val(ad)
          pfq.find(".showOtherText1").append fqtmp   
        #suggestion 
        pfq = modelobj.find(".feedback_sugg").find(".templateBlock")
        for sug in jsonttf.disadvantages
          fqtmp = $(pfq.find(".templateText1").html())
          fqtmp.find(".s1").val(sug)
          pfq.find(".showOtherText1").append fqtmp    
      catch
        pfq = modelobj.find(".feedback_quality").find(".templateBlock")
        defaultarr = [{score:4,text:"ดีมาก"},
                       {score:3,text:"ดี"},
                       {score:2,text:"พอใช้"},
                       {score:1,text:"ควรปรับปรุง"}]
        for ai in defaultarr
          fqtmp = $(pfq.find(".templateText2").html())
          fqtmp.find(".s1").val(ai.score)
          fqtmp.find(".s2").val(ai.text)
          pfq.find(".showOtherText2").append fqtmp
@setroomscore = (modelobj ) ->
      #Task feedback
      ttf = $("#room_ratio_score").val()
      jsonttf = {"results":[{"maxscore":{"text":"คะแนนสอบ","score":"","type":"exam","childs":[]}},{"maxscore":{"text":"คะแนนเก็บ","score":"","type":"saving","childs":[]}}]}
      #jsonttf = {"results":[{"maxscore":{"text":"คะแนนสอบ","score":"20","type":"exam","childs":[{"text":"task 03/สอบกลางภาค","score":"15","id":9}]}},{"maxscore":{"text":"คะแนนเก็บ","score":"80","type":"saving","childs":[{"text":"task 01/การบ้าน","score":"10","id":7}]}}]}
      try
        jsonttf = JSON.parse(ttf)
        #console.log(jsonttf)
      catch
        #
      scorblock = modelobj.find(".scoreblock")  
      for objscore in jsonttf.results
        fqtmpblock = scorblock.find(".showPercent .percent_block[data-type="+objscore.maxscore.type+"]")
        if fqtmpblock.length > 0
          maxscoreblock = fqtmpblock.find(".max-score")
          fqtmpp = $(scorblock.find(".templatePercent").html())
          fqtmpp.find("lable").text(objscore.maxscore.text)
          fqtmpp.find("input").val(objscore.maxscore.score).attr("disabled",(objscore.maxscore.type == "saving") ? "disabled" : false)
          fqtmpp.find(".delete-score-task").remove()
          
          maxscoreblock.append fqtmpp
          
          for childscore in objscore.maxscore.childs
            childscoreblock = fqtmpblock.find(".child-score")
            fqtmpc = $(scorblock.find(".templatePercent").html())
            fqtmpc.find("lable").text(childscore.text)
            fqtmpc.find("input").val(childscore.score).attr("data-id",childscore.id)
            setroomtaskevent(fqtmpc.find("input"))
            setremoveroomtaskevent(fqtmpc.find(".delete-score-task"))
            childscoreblock.find(".content").append fqtmpc
            btncheck = childscoreblock.find(".selecttask[data-id="+childscore.id+"]")
            if btncheck.length > 0
              btncheck.removeClass("btn-primary").addClass("disabled btn-secondary")
            
          calculatewarningtext(fqtmpblock.find(".child-score .content input:first"))   
            
      scorblock.find(".showPercent .max-score input").on 'change',->
        val1int = parseFloat($(this).val(),10)
        val2 = ""
        if !isNaN(val1int)
          val2 = 100 - val1int
        else
          $(this).val("")
        scorblock.find(".showPercent .percent_block[data-type=saving] .max-score input").val(val2)
@setroomgrade = (modelobj ) ->       
    rrg = $("#room_ratio_grade").val()  
    #jsonttf = {"choice":"3","blocks":[{"leftnum":"90","leftnumindex":"1","leftoper":"<=","gtext":"4","rightoper":"<=","rightnum":"100","rightnumindex":"0"},{"leftnum":"80","leftnumindex":"2","leftoper":"<=","gtext":"3","rightoper":"<","rightnum":"90","rightnumindex":"1"},{"leftnum":"60","leftnumindex":"3","leftoper":"<=","gtext":"2","rightoper":"<","rightnum":"80","rightnumindex":"2"},{"leftnum":"50","leftnumindex":"4","leftoper":"<=","gtext":"1","rightoper":"<","rightnum":"60","rightnumindex":"3"},{"leftnum":"0","leftnumindex":"5","leftoper":"<=","gtext":"0","rightoper":"<","rightnum":"50","rightnumindex":"4"}]}
    #jsonttf = {"choice":"","blocks":[]}
    try
      jsonttf = JSON.parse(rrg)
      #console.log(jsonttf)
    catch
      
    if jsonttf?
      $("#ratio_grade_text").val(jsonttf.choice)
      parentblock = $("#ratio_grade_text").closest(".gradezone")
      gradeblock = parentblock.find(".gradeblock")
      for obc in jsonttf.blocks
            fqtmp = $(parentblock.find(".gradboxTemplate").html())
            fqtmp.find(".num-left input").val(obc.leftnum).attr("data-index",obc.leftnumindex)
            fqtmp.find(".oper-left").text(obc.leftoper)
            fqtmp.find(".grade-text input").val(obc.gtext)
            fqtmp.find(".oper-right").text(obc.rightoper)
            fqtmp.find(".num-right input").val(obc.rightnum).attr("data-index",obc.rightnumindex)
            
            gradeblock.append fqtmp
            
      gradeblock.find("input[data-index]").on 'change',->
             currentval = $(this).val()
             dataindex = $(this).data("index")
             $(this).closest(".gradeblock").find("input[data-index="+dataindex+"]").val(currentval)      
@settaskbehaviorextra = (modelobj) ->  
    tbeh = $("#task_task_behavior").val() 
    tbehx = $("#task_task_behavior_extra").val()  
    #jsonttf = {"choice":"3","blocks":[{"leftnum":"90","leftnumindex":"1","leftoper":"<=","gtext":"4","rightoper":"<=","rightnum":"100","rightnumindex":"0"},{"leftnum":"80","leftnumindex":"2","leftoper":"<=","gtext":"3","rightoper":"<","rightnum":"90","rightnumindex":"1"},{"leftnum":"60","leftnumindex":"3","leftoper":"<=","gtext":"2","rightoper":"<","rightnum":"80","rightnumindex":"2"},{"leftnum":"50","leftnumindex":"4","leftoper":"<=","gtext":"1","rightoper":"<","rightnum":"60","rightnumindex":"3"},{"leftnum":"0","leftnumindex":"5","leftoper":"<=","gtext":"0","rightoper":"<","rightnum":"50","rightnumindex":"4"}]}
    #jsonttf = {"choice":"","blocks":[]}
    try
      jsonttf = JSON.parse(tbehx)
    catch
    extrablock = modelobj.find(".task_behavior_extra")
    resultblock = extrablock.find(".result_block")
    resultblock.empty()
    if tbeh == "คะแนน (scoring)"
          ttbtmp = $(extrablock.find(".choice_text_template").html())
          resultblock.append ttbtmp
          if jsonttf? and jsonttf.type == "คะแนน (scoring)"
            ttbtmp.find("input").val(jsonttf.score)
    else if tbeh == "rating scale"
          ttbtmp = $(extrablock.find(".choice_rating_template").html())
          resultblock.append ttbtmp
          if jsonttf? and jsonttf.type == "rating scale"
            resultblock.find(".behabiorRatingNew").val(jsonttf.score)
            for scr in jsonttf.data 
                newtmp = $(resultblock.find(".templateText2").html())
                newtmp.find("input[data-numbertype=1]").val(scr.value1)
                newtmp.find("input[data-numbertype=2]").val(scr.value2)
                resultblock.find(".showTemplateSeleted").append(newtmp)
          
    else if tbeh == "checklist"  
          ttbtmp = $(extrablock.find(".choice_checklist_template").html())
          resultblock.append ttbtmp
          if jsonttf? and jsonttf.type == "checklist"  
            for scr in jsonttf.data 
                newtmp = $(resultblock.find(".templateText2").html())
                newtmp.find("input[data-numbertype=1]").val(scr.value1)
                newtmp.find("input[data-numbertype=2]").val(scr.value2)
                resultblock.find(".showTemplateSeleted").append(newtmp)
    extrablock.find(".behabiorNew").on 'click',->
          newtmp = $(this).closest(".result_block").find(".templateText2").html()
          $(this).closest(".result_block").find(".showTemplateSeleted").append(newtmp)        
    extrablock.find(".behabiorRatingNew").on 'change',->
          valint = parseInt($(this).val(),10)
          if !isNaN(valint)
            resultblock = $(this).closest(".result_block")
            countchilde = resultblock.find(".showTemplateSeleted").children().length
            diff = valint - countchilde
            if diff > 0
              #re index
              resultblock.find(".showTemplateSeleted").children().each (index, element) =>
                $(element).find("input[data-numbertype=1]").val(countchilde + 1 - index)  
              for i in [0...diff] 
                newtmp = $(resultblock.find(".templateText2").html())
                newtmp.find("input[data-numbertype=1]").val(diff - i)
                resultblock.find(".showTemplateSeleted").append(newtmp)
             
          else
            $(this).val("")
@settaskassessmentother = (modelobj) ->   
  assigmentval = modelobj.find("#task_task_assessment").val()
  assignotherval = modelobj.find("#task_task_assignment_other").val()
  modelobj.find(".task_assignment_other_input").val(assignotherval)
  if assigmentval == "อื่นๆ"
     modelobj.find(".task_assignment_other").removeClass("hidden")
$ ->
  modal_holder_selector = '#modal-holder'
  modal_selector = '.modal'

  $(document).on 'click', 'a[data-modal]', ->
    location = $(this).attr('href')
    send_parmas = $(this).data('send-params')
    final_parames_s = ""
    #console.log(send_parmas)
    if send_parmas
      final_parames_s = "?"
      final_parames = []
      for key, value of send_parmas
        pvalue = $("##{value}").val()
        final_parames.push "#{key}=#{pvalue}"
      final_parames_s +=   final_parames.join "&"
      #console.log(final_parames_s)
      location += final_parames_s
    
    #console.log(location)
    #Load modal dialog from server
    $.get location, (data)->
      #console.log(data)
      modelobj = $(modal_holder_selector).html(data)
      $('.datetimepicker').datetimepicker({sideBySide: true})
      
      setbuttonclick(modelobj)
      settaskfeedback(modelobj)
      setroomscore(modelobj)
      setroomgrade(modelobj)
      settaskbehaviorextra(modelobj)
      settaskassessmentother(modelobj)
      
      modelobj.find(modal_selector).modal()
      
    false

  $(document).on 'ajax:success',
    'form[data-modal]', (event, data, status, xhr)->
      url = xhr.getResponseHeader('Location')
      navi = $(event.target).data("navigate")
      func = $(event.target).data("afterfunction")
      #console.log(func)
      switch func
        when "loadapproved" then loadapproved()
        when "updateyear" then updateyear()
        when "updateroom" then updateroom()
        
        
        #send(func)

      if url && navi != false
        # Redirect to url
        window.location = url
      else
        # Remove old modal backdrop
        $('.modal-backdrop').remove()

        # Replace old modal with new one
        $(modal_holder_selector).html(data).
        find(modal_selector).modal()

      false