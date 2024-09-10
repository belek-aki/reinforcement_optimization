// import 'dart:io';
//
// void main() {
//   final file = File('file/test.dxf');
//   // final file = File('file/line.dxf');
//   final lines = file.readAsLinesSync();
//   // int entitiesIndex = lines.indexWhere((line) => line.trim() == '0\nENTITIES');
//   int entitiesIndex = lines.indexOf("ENTITIES");
//   if (entitiesIndex == -1) {
//     print('Секция ENTITIES не найдена.');
//     return;
//   }
//
//   List<List> coordinatesLine = [];
//   List<List> coordinatesPoint = [];
//   List<List> coordinates3DFace = [];
//   bool readingCoordinatesLine = false;
//   bool readingCoordinatesPoint = false;
//   bool readingCoordinates3Dfice = false;
//   String currentCode = '';
//
//   for (int i = entitiesIndex + 2; i < lines.length; i++) {
//     final line = lines[i].trim();
//     if (line == 'ENDSEC') break;
//     if (line == 'LINE') {
//       readingCoordinatesLine = true;
//       readingCoordinatesPoint = false;
//       readingCoordinates3Dfice = false;
//     } else if (line == 'POINT') {
//       readingCoordinatesLine = false;
//       readingCoordinatesPoint = true;
//       readingCoordinates3Dfice = false;
//     } else if (line == '3DFACE') {
//       readingCoordinatesLine = false;
//       readingCoordinatesPoint = false;
//       readingCoordinates3Dfice = true;
//     } else if (readingCoordinatesLine) {
//       // print("LINE: ${line}");
//       final code = int.tryParse(line);
//       // print("CODE: $code");
//       if (code != null) {
//         currentCode = line;
//       } else if (currentCode == '10' ||
//           currentCode == '20' ||
//           currentCode == '30' ||
//           currentCode == '11' ||
//           currentCode == '21' ||
//           currentCode == '31' ||
//           currentCode == '8') {
//         final value = line;
//
//         if (coordinatesLine.isEmpty || coordinatesLine.last.length == 4) {
//           coordinatesLine.add([]);
//         }
//         coordinatesLine.last.add(value);
//       }
//     } else if (readingCoordinatesPoint) {
//       final code = int.tryParse(line);
//       // print("CODE: $code");
//       if (code != null) {
//         currentCode = line;
//       } else if (currentCode == '10' ||
//           currentCode == '20' ||
//           currentCode == '30' ||
//           currentCode == '11' ||
//           currentCode == '21' ||
//           currentCode == '31') {
//         final value = double.tryParse(line);
//         // print("Value: $value");
//         if (value != null) {
//           if (coordinatesPoint.isEmpty || coordinatesPoint.last.length == 3) {
//             coordinatesPoint.add([]);
//           }
//           coordinatesPoint.last.add(value);
//         }
//       }
//     } else if (readingCoordinates3Dfice) {
//       final code = int.tryParse(line);
//       // print("CODE: $code");
//       if (code != null) {
//         currentCode = line;
//       } else if (currentCode == '10' ||
//           currentCode == '20' ||
//           currentCode == '30' ||
//           currentCode == '11' ||
//           currentCode == '21' ||
//           currentCode == '31' ||
//           currentCode == '12' ||
//           currentCode == '22' ||
//           currentCode == '32' ||
//           currentCode == '13' ||
//           currentCode == '23' ||
//           currentCode == '33') {
//         final value = double.tryParse(line);
//         // print("Value: $value");
//         if (value != null) {
//           if (coordinates3DFace.isEmpty || coordinates3DFace.last.length == 3) {
//             coordinates3DFace.add([]);
//           }
//           coordinates3DFace.last.add(value);
//         }
//       }
//     }
//   }
//   // print('COORDINATE: $coordinatesLine');
//
//   for (final coordinate in coordinatesLine) {
//     if (coordinate.length == 4) {
//       print(
//           'Line Layer: ${coordinate[0]}, X: ${coordinate[1]}, Y: ${coordinate[2]}, Z: ${coordinate[3]}');
//     }
//   }
//   for (final coordinate in coordinatesPoint) {
//     if (coordinate.length == 3) {
//       // print(
//       //     'Point X: ${coordinate[0]}, Y: ${coordinate[1]}, Z: ${coordinate[2]}');
//     }
//   }
//   for (final coordinate in coordinates3DFace) {
//     if (coordinate.length == 3) {
//       // print(
//       //     '3dFace X: ${coordinate[0]}, Y: ${coordinate[1]}, Z: ${coordinate[2]}');
//     }
//   }
// }



import 'dart:io';

void main() {
  final file = File('file/test.dxf');
  final lines = file.readAsLinesSync();
  int entitiesIndex = lines.indexOf("ENTITIES");
  if (entitiesIndex == -1) {
    print('Секция ENTITIES не найдена.');
    return;
  }

  List<List> coordinatesLine = [];
  List<List> coordinatesPoint = [];
  List<List> coordinates3DFace = [];
  bool readingCoordinatesLine = false;
  bool readingCoordinatesPoint = false;
  bool readingCoordinates3DFace = false;
  String currentCode = '';
  String? currentLayer; // Переменная для хранения текущего слоя

  for (int i = entitiesIndex + 2; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line == 'ENDSEC') break;

    if (line == 'LINE') {
      readingCoordinatesLine = true;
      readingCoordinatesPoint = false;
      readingCoordinates3DFace = false;
    } else if (line == 'POINT') {
      readingCoordinatesLine = false;
      readingCoordinatesPoint = true;
      readingCoordinates3DFace = false;
    } else if (line == '3DFACE') {
      readingCoordinatesLine = false;
      readingCoordinatesPoint = false;
      readingCoordinates3DFace = true;
    } else if (readingCoordinatesLine) {
      final code = int.tryParse(line);
      if (code != null) {
        currentCode = line;
      } else if (currentCode == '10' ||
          currentCode == '20' ||
          currentCode == '30' ||
          currentCode == '11' ||
          currentCode == '21' ||
          currentCode == '31' ||
          currentCode == '8') {
        final value = line;

        if (currentCode == '8') {
          currentLayer = value; // Сохраняем текущий слой
        } else {
          if (coordinatesLine.isEmpty || coordinatesLine.last.length == 4) {
            coordinatesLine.add([currentLayer]); // Добавляем слой как первый элемент
          }
          coordinatesLine.last.add(value);
        }
      }
    } else if (readingCoordinatesPoint) {
      final code = int.tryParse(line);
      if (code != null) {
        currentCode = line;
      } else if (currentCode == '10' ||
          currentCode == '20' ||
          currentCode == '30') {
        final value = double.tryParse(line);
        if (value != null) {
          if (coordinatesPoint.isEmpty || coordinatesPoint.last.length == 3) {
            coordinatesPoint.add([currentLayer]); // Добавляем слой как первый элемент
          }
          coordinatesPoint.last.add(value);
        }
      }
    } else if (readingCoordinates3DFace) {
      final code = int.tryParse(line);
      if (code != null) {
        currentCode = line;
      } else if (currentCode == '10' ||
          currentCode == '20' ||
          currentCode == '30' ||
          currentCode == '11' ||
          currentCode == '21' ||
          currentCode == '31' ||
          currentCode == '12' ||
          currentCode == '22' ||
          currentCode == '32' ||
          currentCode == '13' ||
          currentCode == '23' ||
          currentCode == '33') {
        final value = double.tryParse(line);
        if (value != null) {
          if (coordinates3DFace.isEmpty || coordinates3DFace.last.length == 3) {
            coordinates3DFace.add([currentLayer]); // Добавляем слой как первый элемент
          }
          coordinates3DFace.last.add(value);
        }
      }
    }
  }

  // Вывод координат для LINE с учетом слоя
  for (final coordinate in coordinatesLine) {
    if (coordinate.length == 5) {
      print(
          'Line Layer: ${coordinate[0]}, X: ${coordinate[1]}, Y: ${coordinate[2]}, Z: ${coordinate[3]}, X2: ${coordinate[4]}');
    }
  }

  // Вывод координат для POINT с учетом слоя
  for (final coordinate in coordinatesPoint) {
    if (coordinate.length == 4) {
      print(
          'Point Layer: ${coordinate[0]}, X: ${coordinate[1]}, Y: ${coordinate[2]}, Z: ${coordinate[3]}');
    }
  }

  // Вывод координат для 3DFACE с учетом слоя
  for (final coordinate in coordinates3DFace) {
    if (coordinate.length == 4) {
      print(
          '3DFace Layer: ${coordinate[0]}, X: ${coordinate[1]}, Y: ${coordinate[2]}, Z: ${coordinate[3]}');
    }
  }
}
