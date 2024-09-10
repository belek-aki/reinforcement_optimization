import 'package:dxf_parsing_test/data_1.dart';
import 'package:dxf_parsing_test/data_2.dart';

void main() {
  Map<String, int> coordinateIndices = {};
  int index = 1;
  List result = [];

  for (var item in data2) {
    var newItem = {};
    var key = item.keys.first;
    var coordinatesList = item[key]!;
    List indexedCoordinates = coordinatesList.map((coordinate) {
      String coordinateKey = coordinate.join(',');
      // print("coordinateIndices: $coordinateIndices");
      if (!coordinateIndices.containsKey(coordinateKey)) {
        coordinateIndices[coordinateKey] = index;
        index++;
      }
      return coordinateIndices[coordinateKey]!;
    }).toList();
    newItem[key] = indexedCoordinates;
    result.add(newItem);
  }
  print(result);
}
