var init_product_lookup;

init_product_lookup = function(){

$('#product-lookup-form').on('ajax:before', function(event, data, status){

show_spinner();

});

$('#product-lookup-form').on('ajax:after', function(event, data, status){

hide_spinner();

});

$('#product-lookup-form').on('ajax:success', function(event, data, status){

$('#product-lookup').replaceWith(data);

init_product_lookup();

});

$('#product-lookup-form').on('ajax:error', function(event, xhr, status, error){

hide_spinner();

$('#product-lookup-results').replaceWith(' ');

$('#product-lookup-errors').replaceWith('Person was not found.');

});

}

$(document).ready(function() {

init_product_lookup();

})