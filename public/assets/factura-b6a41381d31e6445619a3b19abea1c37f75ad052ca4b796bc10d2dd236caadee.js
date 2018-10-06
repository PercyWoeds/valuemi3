



jQuery(function() {
  var note_concepts;
  $('#factura_note_concept_id').parent().hide();
  note_concepts = $('#factura_note_concept_id').html();
 console.log(note_concepts);
  return $('#factura_document_id').change(function() {
    var documento, escaped_documento, options;
    documento = $('#factura_document_id :selected').text();
    
  
    
    options = $(note_concepts).filter("optgroup[label=" + documento + "]").html();
 console.log(options);
 
    if (options) {
      $('#factura_note_concept_id').html(options);
      return $('#factura_note_concept_id').parent().show();
    } else {
      $('#factura_note_concept_id').empty();
      return $('#factura_note_concept_id').parent().hide();
    }
  });
});
