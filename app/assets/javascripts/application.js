// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require popper
//= require bootstrap-sprockets
//= require rails.validations
//= require rails.validations.simple_form
//= require select2-full
//= require_tree .


var ready = function() {
    // do stuff here.
     $(".alert,.notice-alert" ).fadeOut(3000);
     $('#user_school_id').select2({
          ajax: {
                url: '/allschools',
                dataType: 'json',
                delay: 250,
                data: function(params) {
                    return {
                        term: params.term,
                        page: params.page,
                        page_limit: 50
                    };
                },
                processResults: function(data, page) {
                   // console.log(data)
                    return {
                        results: data.schools
                    };
                },
                cache: true
            },
            escapeMarkup: function(markup) {
                return markup;
            },
            //allowClear: true,
            //placeholder: "ชื่อสถานศึกษา*",
            templateResult: function(school) {
                if(typeof school.school_name !== "undefined")
                
                    return school.school_name
                
                return school.school_name
            },
            templateSelection: function(school) {
                
                if(typeof school.school_name !== "undefined")
                
                    return school.school_name
                
               return "ชื่อสถานศึกษา*"
            }
        });
   /* $(document).on("change", "#year", function(){
          var year = $(this).val();
         // console.log(year)
           //$("#course").empty()  
          $.ajax({
            url: "/managecourse",
            method: "GET",
            dataType: "json",
            data: {year: year},
            error: function (xhr, status, error) {
              console.error('AJAX Error: ' + status + error);
            },
            success: function (response) {
              console.log(response);
              var courses = response["courses"];
              $("#course").empty();
        
              $("#course").append('<option>Select courses</option>');
              for(var i=0; i< courses.length; i++){
                $("#course").append('<option value="' + courses[i]["id"] + '">' + courses[i]["couse_name"] + '</option>');
              }
            }
          });
        });    */
};
$(document).on('shown.bs.modal', '.modal', function() {
  $('form[data-client-side-validations]').enableClientSideValidations();
});
$(document).on('turbolinks:load', ready); 
    /*    $.ajax({
        type: 'GET',
        url: "https://mail.zoho.com/api/accounts/666798532/messages/view",
        headers: {
            "Authorization":"Zoho-authtoken 2f974a2c779edc37ff10c0dab6c384d3"
        },
        crossDomain: true,
        dataType: "JSONP"
        //OR
        //beforeSend: function(xhr) { 
        //  xhr.setRequestHeader("My-First-Header", "first value"); 
        //  xhr.setRequestHeader("My-Second-Header", "second value"); 
        //}
    }).done(function(data) { 
        console.log(data);
    }).fail(function(err,s,m) { 
        console.log(err);
        console.log(s);
        console.log(m);
    });*/
