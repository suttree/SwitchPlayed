// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var timer = null

function start_timer(){
    var time = new Date()
    var hours = time.getHours()
    var minutes = time.getMinutes()
    minutes=((minutes < 10) ? "0" : "") + minutes
    var seconds = time.getSeconds()
    seconds=((seconds < 10) ? "0" : "") + seconds
    var clock = hours + ":" + minutes + ":" + seconds
    document.forms[0].room_timer.value = clock
    timer = setTimeout("start_timer()",1000)
}
