var init__lookup;

init_oservice_lookup = function(){

alert ("holaaa");

$('#oservice-lookup-form').on('ajax:before', function(event, data, status){

show_spinner();

});

$('#oservice-lookup-form').on('ajax:after', function(event, data, status){

hide_spinner();

});

$('#oservice-lookup-form').on('ajax:success', function(event, data, status){

$('#oservice-lookup').replaceWith(data);

init_oservice_lookup();

});

$('#oservice-lookup-form').on('ajax:error', function(event, xhr, status, error){

hide_spinner();

$('#oservice-lookup-results').replaceWith(' ');

$('#oservice-lookup-errors').replaceWith('Person was not found.');

});

}

$(document).ready(function() {

init_oservice_lookup();

})



