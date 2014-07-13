RECURRING_EVENTS_UPTO = (Date.today.beginning_of_year + 1.years).to_time
Fullcalendar::Configuration = {
  'editable'    => false,
  'header'      => {
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek,agendaDay'
  },
  'defaultView' => 'month',
  'height'      => 500,
  'slotMinutes' => 15,
  'dragOpacity' => 0.5,
  'selectable'  => true,
  'timeFormat'  => "h:mm t{ - h:mm t}",
  'events'      => '/events/get_events',
  'disableDragging' => true
}
