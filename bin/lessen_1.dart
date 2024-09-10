import 'package:dxf_parsing_test/data_1.dart';

void main() {
  Map<String, int> coordinateIndices = {};
  int index = 0;
  List result = [];

  for (var item in data1) {
    var key = item.keys.first; // Получаем ключ
    var coordinatesList = item[key]!;
    var indexedCoordinates = coordinatesList.map((coordinate) {
      String coordinateKey = coordinate.join(',');
      return coordinateIndices.putIfAbsent(coordinateKey, () => index++);
    }).toList();
    result.add({key: indexedCoordinates});
  }
  print(result);
}
