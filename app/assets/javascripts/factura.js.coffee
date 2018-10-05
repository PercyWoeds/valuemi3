# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#factura_note_concept_id').parent().hide()
  note_concepts = $('#factura_note_concept_id').html()
  console(note_concepts).log 
  $('#factura_document_id').change ->
    document  = $('#factura_document_id :selected').text()
    escaped_document = document.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(note_concepts).filter("optgroup[label='#{escaped_document}']").html()
    if options
      $('#factura_note_concept_id').html(options)
      $('#factura_note_concept_id').parent().show()
    else
      $('#factura_note_concept_id').empty()