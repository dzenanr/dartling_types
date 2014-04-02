part of entities_table_wc;

class EntityTable { 
  List<Attribute> nonIncrementAttributes;
  Entities entities;
  ConceptEntity currentEntity;
  
  TableElement table = querySelector('#entity-table');
  ButtonElement addButton = querySelector('#add-button');
  ButtonElement updateButton = querySelector('#update-button');
  ButtonElement removeButton = querySelector('#remove-button');
  ButtonElement cancelButton = querySelector('#cancel-button');
  
  EntitiesTable entitiesTable;
  
  EntityTable(this.entitiesTable, this.entities) {   
    nonIncrementAttributes = entities.concept.nonIncrementAttributes;
    addEventHandlers();
    display();
    firstField().focus();
  } 
  
  addEventHandlers() {
    addButton.onClick.listen(addEntity);
    updateButton.onClick.listen(updateEntity);
    removeButton.onClick.listen(removeEntity);
    cancelButton.onClick.listen(cancelAction);
  }
  
  display() {
    addCaption();
    for (Attribute attribute in nonIncrementAttributes) {
      addRow(attribute);
    }
  }
  
  addCaption() {
    var tableCaption = new TableCaptionElement();
    tableCaption.text = entities.concept.label;
    table.nodes.add(tableCaption);
  }
  
  addRow(Attribute attribute) {
    TableRowElement row = new Element.tr();
        
    TableCellElement thElement = new Element.th();
    thElement.text = attribute.label;
    row.nodes.add(thElement);
    
    TableCellElement tdElement = new Element.td();
    var inputElement;
    if (attribute.type.code == 'bool') {
      inputElement = new CheckboxInputElement();
    } else {
      inputElement = new InputElement();
    }
    if (attribute.required) {
      inputElement.attributes['required'] = 'required';
    }
    if (attribute.length != null) {
      inputElement.attributes['size'] = attribute.length.toString();
    }
    tdElement.nodes.add(inputElement);
    row.nodes.add(tdElement);
    
    row.id = attribute.oid.toString();
    table.nodes.add(row);
  }
  
  InputElement firstField() {
    return table.rows[0].nodes[1].nodes[0];
  }
  
  InputElement rowField(TableRowElement row) {
    return row.nodes[1].nodes[0];
  }
  
  TableRowElement findRow(Attribute attribute) {
    for (int i = 0; i < table.rows.length; i++) {
      TableRowElement row = table.rows[i];
      if (row.id == attribute.oid.toString()) {
        return row;
      } 
    }
    return null;
  }
  
  setRow(var entity, Attribute attribute) {
    var dRow = findRow(attribute);
    var field = rowField(dRow);
    var attributeValue = entity.getStringOrNullFromAttribute(attribute.code);
    if (attribute.type.code == 'bool') {
      field.checked = attributeValue == 'true' ? true : false;
    } else {
      field.value = attributeValue;
    }
  }
  
  emptyData() {
    for (int i = 0; i < table.rows.length; i++) {
      TableRowElement row = table.rows[i];
      var field = rowField(row);
      var attribute = getAttribute(row);
      if (attribute.type.code == 'bool') {
        field.checked = false;
      } else {
        field.value = '';
      }
    }
  }
  
  Attribute getAttribute(var row) {
    var oid = new Oid.ts(int.parse(row.id));
    return entities.concept.attributes.singleWhereOid(oid);
  }
  
  setEntity(var entity) {
    for (Attribute attribute in nonIncrementAttributes) {
      setRow(entity, attribute);
    }
    currentEntity = entity;
  }
  
  validateValueType(Attribute attribute, String value) {
    if (attribute.type.code == 'DateTime') {
      try {
        DateTime.parse(value);
      } on FormatException catch (e) {
        return false;
      }
    } else if (attribute.type.code == 'int') {
      try {
        int.parse(value);
      } on FormatException catch (e) {
        return false;
      }
    } else if (attribute.type.code == 'double') {
      try {
        double.parse(value);
      } on FormatException catch (e) {
        return false;
      }
    } else if (attribute.type.code == 'num') {
      try {
        num.parse(value);
      } on FormatException catch (e) {
        return false;
      }
    } else if (attribute.type.code == 'Uri') {
      var uri = Uri.parse(value);
      if (uri.host == '') {
        return false;
      }
    }
    return true;
  }
  
  addEntity(Event e) {
    var newEntity = entities.newEntity();
    for (Attribute attribute in nonIncrementAttributes) {
      var row = findRow(attribute);
      if (attribute.type.code == 'bool') {
        newEntity.setAttribute(attribute.code, rowField(row).checked);
      } else {
        var value = rowField(row).value;
        if (value != '') {
          if (validateValueType(attribute, value)) {
            newEntity.setStringToAttribute(attribute.code, value);
          }
        }
      }    
    }
    var added = entities.add(newEntity);
    entitiesTable.display();
    entitiesTable.save();
    setEntity(newEntity);
    firstField().focus();
  }
  
  updateEntity(Event e) {
    var nonIdentifierAttributes = currentEntity.concept.nonIdentifierAttributes;
    for (Attribute attribute in nonIdentifierAttributes) {
      if (attribute.increment == null) {
        var row = findRow(attribute);      
        if (attribute.type.code == 'bool') {
          currentEntity.setAttribute(attribute.code, rowField(row).checked);
        } else {
          var value = rowField(row).value;
          if (attribute.required) {
            if (value != '') {
              if (validateValueType(attribute, value)) {
                currentEntity.setStringToAttribute(attribute.code, value);
              }
            }
          } else {
            if (value != '') {
              if (validateValueType(attribute, value)) {
                currentEntity.setStringToAttribute(attribute.code, value);
              }
            } else {
              currentEntity.setStringToAttribute(attribute.code, null);
            }       
          }           
        }      
      }
    }
    entitiesTable.display();
    entitiesTable.save();
    firstField().focus();
  }
  
  removeEntity(Event e) {
    if (removeButton.text == 'Remove') {
      removeButton.text = 'Confirm';
    } else {
      var removed = entities.remove(currentEntity);
      assert(removed);
      entitiesTable.display();
      entitiesTable.save();
      emptyData();
      firstField().focus();
      currentEntity = null;
      removeButton.text = 'Remove';
    }
  }
  
  cancelAction(Event e) {
    emptyData();
    firstField().focus();
    currentEntity = null;
  } 
}