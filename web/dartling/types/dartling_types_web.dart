 
// web/dartling/types/dartling_types_web.dart 
 
import "dart:html"; 
 
import "package:dartling_default_app/dartling_default_app.dart"; 
import "package:dartling_types/dartling_types.dart"; 
 
initData(Repository repository) { 
   var dartlingDomain = repository.getDomainModels("Dartling"); 
   var typesModel = dartlingDomain.getModelEntries("Types"); 
   typesModel.init(); 
   //typesModel.display(); 
} 
 
showData(Repository repository) { 
   var mainView = new View(document, "main"); 
   mainView.repo = repository; 
   new RepoMainSection(mainView); 
} 
 
void main() { 
  var repository = new Repository(); 
  initData(repository); 
  showData(repository); 
} 
 
