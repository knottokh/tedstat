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
    
    console.log(location)
    #Load modal dialog from server
    $.get location, (data)->
      #console.log(data)
      $(modal_holder_selector).html(data).
      find(modal_selector).modal()
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