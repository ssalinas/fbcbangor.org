// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(window).resize(function(){
  if($(window).width() <= 700) {
    $('.calendar').fullCalendar('changeView', 'basicWeek','gotoDate', gon.startDate);
    $('.calendar').fullCalendar('option', 'height', 200);
  } else if($(window).width() < 900 ) {
    $('.calendar').fullCalendar('changeView', 'basicWeek','gotoDate', gon.startDate);
    $('.calendar').fullCalendar('option', 'height', 300);
  } else {
    $('.calendar').fullCalendar('changeView', 'month','gotoDate', gon.startDate);
  }
});

$.extend(gon.full_calendar_options, {
  loading: function(bool){
    if (bool)
      $('#loading').show();
    else
      $('#loading').hide();
  },
  eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
    FullcalendarEngine.Events.move(event, dayDelta, minuteDelta, allDay);
  },
  eventResize: function(event, dayDelta, minuteDelta, revertFunc){
    FullcalendarEngine.Events.resize(event, dayDelta, minuteDelta);
  },
  eventClick: function(event, jsEvent, view){
    FullcalendarEngine.Events.showEventDetails(event);
  },
  select: function( startDate, endDate, allDay, jsEvent, view ) {
    if (gon.full_calendar_options['editable'] == true) {
      FullcalendarEngine.Form.display({
        starttime: new Date(startDate.getTime()),
        endtime:   new Date(endDate.getTime()),
        allDay:    allDay
      })
    }
  }
})

if (typeof(FullcalendarEngine) === 'undefined') { FullcalendarEngine = {}; }

FullcalendarEngine = {
  Form: {
    display: function(options) {
      if (typeof(options) == 'undefined') { options = {} }
      FullcalendarEngine.Form.fetch(options)
    },
    render: function(options){
      $('#event_form').trigger('reset');
      var startTime = options['starttime'] || new Date(), endTime = options['endtime'] || new Date(startTime.getTime());
      if(startTime.getTime() == endTime.getTime()) { endTime.setMinutes(startTime.getMinutes() + 15); }
      FullcalendarEngine.setTime('#event_starttime', startTime)
      FullcalendarEngine.setTime('#event_endtime', endTime)
      $('#event_all_day').attr('checked', options['allDay'])
      $('#create_event_dialog').dialog({
        title: 'New Event',
        modal: true,
        width: 500,
        close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
      });
    },
    fetch: function(options){
      $.ajax({
        type: 'get',
        dataType: 'script',
        async: true,
        url: "/events/new",
        success: function(){ FullcalendarEngine.Form.render(options) }
      });
    },
    authenticity_token: function(){
      return($('meta[name="csrf-token"]').attr("content"))
    }
  },
  Events: {
    move: function(event, dayDelta, minuteDelta, allDay){
      $.ajax({
        data: 'title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay + '&authenticity_token=' + FullcalendarEngine.Form.authenticity_token(),
        dataType: 'script',
        type: 'post',
        url: "/events/" + event.id + "/move",
        error: function(xhr){
          alert(JSON.parse(xhr.responseText)["message"])
        }
      });
    },
    resize: function(event, dayDelta, minuteDelta){
      $.ajax({
        data: 'title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&authenticity_token=' + FullcalendarEngine.Form.authenticity_token(),
        dataType: 'script',
        type: 'post',
        url: "/events/" + event.id + "/resize",
        error: function(xhr){
          alert(JSON.parse(xhr.responseText)["message"])
        }
      });
    },
    edit: function(event_id){
      $.ajax({
        url: "/events/" + event_id + "/edit",
        success: function(data) {
          $('#edit_event_description').html(data['form']);
        }
      });
    },
    delete: function(event_id, delete_all){
      $.ajax({
        data: 'authenticity_token=' + FullcalendarEngine.Form.authenticity_token() + '&delete_all=' + delete_all,
        dataType: 'script',
        type: 'delete',
        url: "/events/" + event_id,
        success: FullcalendarEngine.Events.refetch_events_and_close_dialog
      });
    },
    refetch_events_and_close_dialog: function() {
      $('.calendar').fullCalendar('refetchEvents');
      $('.dialog:visible').dialog('destroy');
    },
    showEventDetails: function(event){
      $('#event_desc_dialog').html('')
      $event_description  = $('<div />').html(event.description).attr("id", "edit_event_description")
      if (gon.full_calendar_options['editable'] == true) {
        $event_actions      = $('<div />').attr("id", "event_actions")
        $edit_event         = $('<span />').attr("id", "edit_event").html("<a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.edit(" + event.id + ")'>Edit</a>");
        $delete_event       = $('<span />').attr("id", "delete_event")
      }
      if (event.recurring) {
        title = event.title + "(Recurring)";
        if (gon.full_calendar_options['editable'] == true) {
          // Cannot be refactored as of now, the event bubbling of the eventClick of the fullCalendar is the culprit
          $delete_event.html("&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.delete(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
          $delete_event.append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.delete(" + event.id + ", " + true + ")'>Delete All In Series</a>")
          $delete_event.append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.delete(" + event.id + ", \"future\")'>Delete All Future Events</a>")
        }
      } else {
        title = event.title;
        if (gon.full_calendar_options['editable'] == true) {
          $delete_event.html("<a href = 'javascript:void(0);' onclick ='FullcalendarEngine.Events.delete(" + event.id + ", " + false + ")'>Delete</a>");
        }
      }
      if (gon.full_calendar_options['editable'] == true) {
        $event_actions.append($edit_event).append(" | ").append($delete_event)
        $('#event_desc_dialog').append($event_description).append($event_actions)
      } else {
        $('#event_desc_dialog').append($event_description)
      }
      $('#event_desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){ $('#event_desc_dialog').html(''); $('#event_desc_dialog').dialog('destroy') }
      });
    },
    showPeriodAndFrequency: function(value){
      switch (value) {
        case 'Daily':
          $('#period').html('day');
          $('#frequency').show();
          break;
        case 'Weekly':
          $('#period').html('week');
          $('#frequency').show();
          break;
        case 'Monthly':
          $('#period').html('month');
          $('#frequency').show();
          break;
        case 'Yearly':
          $('#period').html('year');
          $('#frequency').show();
          break;
        default:
          $('#frequency').hide();
      }
    }
  },
  setTime: function(type, time) {
    var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
    $year.val(time.getFullYear());
    $month.prop('selectedIndex', time.getMonth());
    $day.prop('selectedIndex', time.getDate() - 1);
    $hour.prop('selectedIndex', time.getHours());
    $minute.prop('selectedIndex', time.getMinutes());
  },
}

$(document).ready(function(){
  $('#create_event_dialog, #event_desc_dialog').on('submit', "#event_form", function(event) {
    var $spinner = $('.spinner');
    event.preventDefault();
    $.ajax({
      type: "POST",
      data: $(this).serialize(),
      url: $(this).attr('action'),
      beforeSend: show_spinner,
      complete: hide_spinner,
      success: FullcalendarEngine.Events.refetch_events_and_close_dialog,
      error: handle_error
    });

    function show_spinner() {
      $spinner.show();
    }

    function hide_spinner() {
      $spinner.hide();
    }

    function handle_error(xhr) {
      alert(xhr.responseText);
    }
  })
});
