@setbuttonclick = (modelobj ) ->
      $(".newOtherText1").on 'click',->
          newtmp = $(this).closest(".templateBlock").find(".templateText1").html()
          $(this).closest(".templateBlock").find(".showOtherText1").append(newtmp)
      $(".newOtherText2").on 'click',->
          newtmp = $(this).closest(".templateBlock").find(".templateText2").html()
          $(this).closest(".templateBlock").find(".showOtherText2").append(newtmp)  
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
      try
        jsonttf = JSON.parse(ttf)
        #console.log(jsonttf)
      catch
        defaultarr = [{text:"คะแนนสอบ",score:"",type:"exam"},
                       {text:"คะแนนเก็บ",score:"",type:"saving"}]
        scorblock = modelobj.find(".scoreblock")
        for ai in defaultarr
          selectblock = "examscoreblock"
          if ai.type == "saving"
            selectblock= "savingscoreblock"
          fqtmp = $(scorblock.find(".templatePercent").html())
          fqtmp.find("lable").text(ai.text)
          fqtmp.find("input").val(ai.score).attr("disabled",(ai.type == "saving") ? "disabled" : false)
          
          fqtmp.find("input").on 'change',->
            val1int = parseFloat($(this).val(),10)
            val2 = ""
            if !isNaN(val1int)
              val2 = 100 - val1int
            else
              $(this).val("")
            scorblock.find(".showPercent .savingscoreblock .max-score input").val(val2)
            
          scorblock.find(".showPercent .#{selectblock} .max-score").append fqtmp
        defexamarr = [{text:"กลางภาค",score:""},
                       {text:"ปลายภาค",score:""}]  
        for ay in defexamarr               
          fqtmp = $(scorblock.find(".templatePercent").html())
          fqtmp.find("lable").text(ay.text)
          fqtmp.find("input").val(ay.score)
          
          scorblock.find(".showPercent .examscoreblock .child-score").append fqtmp
        
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
      
      modelobj.find(modal_selector).modal()
      
    false

  $(document).on 'ajax:success',
    'form[data-modal]', (event, data, status, xhr)->
      url = xhr.getResponseHeader('Location')
      navi = $(event.target).data("navigate")
      func = $(event.target).data("afterfunction")
      console.log(func)
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