library entities_table_wc;

import 'dart:html';

import "package:dartling/dartling.dart";

part 'entities_table_wc/entities_table.dart';
part 'entities_table_wc/entity_table.dart';

class EntitiesTableWc {
  var app;
 
  EntitiesTable entitiesTable;
  EntityTable entityTable;
  
  EntitiesTableWc(this.app, var entities) {
    entitiesTable = new EntitiesTable(this, entities);
    entityTable = new EntityTable(entitiesTable, entities);  
  }
  
  save() {
    app.save();
  }
}