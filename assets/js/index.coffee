$ =>

  # Configure editor with person schema
  editor = new JSONEditor $('#profile').get(0),
    theme: 'bootstrap3'
    ajax: true
    schema:
      "$ref": "/json/person.schema.json"
    disable_collapse: true
    disable_edit_json: true
    disable_properties: true
    disable_array_reorder: true

  # Load person
  $.getJSON '/json/dylan_boyd.json', (val) =>
    editor.on 'ready', =>
      editor.setValue val
