import 'package:dartling_types/dartling_types.dart';
import 'package:dartling_types/dartling_types_app.dart';

main() {
  var repository = new Repository(); 
  DartlingModels domain = repository.getDomainModels('Dartling');
  new TypesApp(domain);
}