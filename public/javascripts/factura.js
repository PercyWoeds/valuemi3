
jQuery(function() {
  var states;
  $('#factura_note_concept_id').parent().hide();
  note_concepts = $('#factura_note_concept_id').html();
  console.log(note_concepts);
  return $('#factura_document_id').change(function() {
    var documento, escaped_documento, options;
    documento = $('#factura_document_id :selected').text();
    escaped_documento = documento.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(note_concepts).filter("optgroup[label=" + escaped_documento + "]").html();
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
