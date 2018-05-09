# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#$ ->
#    $('#user_school_id').select2
#            ajax: {
#                url: '/allschools'
#                dataType: 'json'
#                delay: 250
#                data: (params) ->
#                    return {
#                        term: params.term,
#                        page: params.page,
#                        page_limit: 50
#                    }
#                processResults: (data, page) ->
#                   # console.log(data)
#                    return {
#                        results: data.schools
#                    }
#                cache: true
#            }
#            escapeMarkup:(markup) -> 
#                markup
#            templateResult: (school) ->
#                school.school_name
#            templateSelection: (school) ->
#                school.school_name || "ชื่อสถานศึกษา*"
            