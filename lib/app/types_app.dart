part of dartling_types_app;

class TypesApp {
  TypesEntries model;
  
  TypesApp(DartlingModels domain) {
    model = domain.getModelEntries("Types"); 
    _load(model);
    new EntitiesTableWc(this, model.types);
  }
  
  _load(TypesEntries model) {
    String json = window.localStorage['dartling_types_data'];
    if (json != null && model.isEmpty) {
      model.fromJson(json);
    }
  }
  
  save() {
    window.localStorage['dartling_types_data'] = model.toJson();
  }
}



