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
//= require moment
//= require moment/th.js
//= require pickers
//= require bootstrap-datetimepicker
//= require rails.validations
//= require rails.validations.simple_form
//= require select2-full
//= require Chart.bundle
//= require highcharts
//= require chartkick
//= require_tree .
var AdminThemeScript = function(){
    $(".sidebar .sidebar-menu li a").on("click", function () {
        var t = $(this);
        t.parent().hasClass("open") ? t.parent().children(".dropdown-menu").slideUp(200, function () {
            t.parent().removeClass("open")
        }
        ) : (t.parent().parent().children("li.open").children(".dropdown-menu").slideUp(200), t.parent().parent().children("li.open").children("a").removeClass("open"), t.parent().parent().children("li.open").removeClass("open"), t.parent().children(".dropdown-menu").slideDown(200, function () {
            t.parent().addClass("open")
        }
        ))
    }
            );
    $(".sidebar-toggle").on("click", function (t) {
        $(".app").toggleClass("is-collapsed"), t.preventDefault()
    }
    );
   // $("body").niceScroll();
    //$(".sidebar-menu").mCustomScrollbar({theme:"dark",autoHideScrollbar:true});
	$('[data-toggle="tooltip"]').tooltip(); 
    
}
var SidebarCollapse  = function () {
    $('.menu-collapsed').toggleClass('d-none');
    $('.sidebar-submenu').toggleClass('d-none');
    $('.submenu-icon').toggleClass('d-none');
    $('#sidebar-container').toggleClass('sidebar-expanded sidebar-collapsed');
    $('#body-row').toggleClass('sidebar-expanded sidebar-collapsed');
    // Treating d-flex/d-none on separators with title
    var SeparatorTitle = $('.sidebar-separator-title');
    if ( SeparatorTitle.hasClass('d-flex') ) {
        SeparatorTitle.removeClass('d-flex');
    } else {
        SeparatorTitle.addClass('d-flex');
    }
    
    // Collapse/Expand icon
    //$('#collapse-icon').toggleClass('fa-angle-double-left fa-angle-double-right');
}
var ready = function() {
     // Hide submenus
     
    $('#body-row .collapse').collapse('hide'); 
    
    // Collapse/Expand icon
    //$('#collapse-icon').addClass('fa-angle-double-left'); 
    
    // Collapse click
    $('[data-toggle=sidebar-colapse]').click(function() {
        SidebarCollapse();
    });

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
        })/*.on('select2:select', function (event) {
          console.log($(event.target).val())
          console.log(event.params.data)
            
        });*/
     AdminThemeScript();   
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
$(document).on("page:fetch", function(){
  $("#spinner-main").show();
});

$(document).on("page:receive", function(){
  $("#spinner-main").hide();
});
$(document).on('shown.bs.modal', '.modal', function() {
  $('form[data-client-side-validations]').enableClientSideValidations();
});
$(document).on('turbolinks:load', ready); 
