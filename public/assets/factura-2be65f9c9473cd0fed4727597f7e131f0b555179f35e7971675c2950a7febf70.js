(function() {
  jQuery(function() {
    var note_concepts;
    $('#factura_note_concept_id').parent().hide();
    note_concepts = $('#factura_note_concept_id').html();
    console(note_concepts).log;
    return $('#factura_document_id').change(function() {
      var document, escaped_document, options;
      document = $('#factura_document_id :selected').text();
      escaped_document = document.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
      options = $(note_concepts).filter("optgroup[label='" + escaped_document + "']").html();
      if (options) {
        $('#factura_note_concept_id').html(options);
        return $('#factura_note_concept_id').parent().show();
      } else {
        return $('#factura_note_concept_id').empty();
      }
    });
  });

}).call(this);
