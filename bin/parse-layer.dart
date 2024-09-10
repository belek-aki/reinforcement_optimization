// // // import 'dart:io';
// // //
// // // void main() {
// // //   final file = File('file/line.dxf');
// // //   final lines = file.readAsLinesSync();
// // //   int entitiesIndex = lines.indexOf("ENTITIES");
// // //   // print("index of: $entitiesIndex");
// // //
// // //
// // //   List coordinates = [];
// // //   Map currentFaceVertices = {};
// // //
// // //   // print("Line: $lines");
// // //
// // //   for (int i = entitiesIndex; i < lines.length; i++) {
// // //     final line = lines[i].trim();
// // //     if (line == 'ENDSEC') break;
// // //     print('I: $i ------- $coordinates');
// // //     if (line != "ENDSEC") {
// // //       currentFaceVertices[lines[i + 1].trim()] = lines[i + 2].trim();
// // //       // print('Line: $currentFaceVertices');
// // //       if (line == '10') {
// // //         var currentIndex = i;
// // //         coordinates.add([lines[currentIndex + 1], lines[currentIndex + 3]]);
// // //         // print('Coordinates: $coordinates');
// // //       }
// // //     }
// // //
// // //   }
// // //   for (final coordinate in coordinates) {
// // //     if (coordinate.length == 2) {
// // //       print('X: ${coordinate[0]}, Y: ${coordinate[1]}');
// // //     }
// // //   }
// // // }
// //
// // import 'dart:io';
// //
// // void main() {
// //   final file = File('file/test.dxf');
// //   // final file = File('file/line.dxf');
// //   final lines = file.readAsLinesSync();
// //   // int entitiesIndex = lines.indexWhere((line) => line.trim() == '0\nENTITIES');
// //   int entitiesIndex = lines.indexOf("ENTITIES");
// //   if (entitiesIndex == -1) {
// //     print('Секция ENTITIES не найдена.');
// //     return;
// //   }
// //
// //   List<List> coordinatesLine = [];
// //   bool readingCoordinatesLine = false;
// //   String currentCode = '';
// //
// //   for (int i = entitiesIndex + 2; i < lines.length; i++) {
// //     final line = lines[i].trim();
// //     if (line == 'ENDSEC') break;
// //     if (line == 'LINE') {
// //       readingCoordinatesLine = true;
// //     } else if (readingCoordinatesLine) {
// //       // print("LINE: ${line}");
// //       final code = int.tryParse(line);
// //       // print("CODE: $code");
// //       if (code != null) {
// //         currentCode = line;
// //       } else if (currentCode == '10' ||
// //           currentCode == '20' ||
// //           currentCode == '30' ||
// //           currentCode == '11' ||
// //           currentCode == '21' ||
// //           currentCode == '31' ||
// //           currentCode == '8') {
// //         final value = line;
// //
// //         if (coordinatesLine.isEmpty || coordinatesLine.last.length == 4) {
// //           coordinatesLine.add([]);
// //         }
// //         coordinatesLine.last.add(value);
// //       }
// //     }
// //   }
// //
// //   for (final coordinate in coordinatesLine) {
// //     if (coordinate.length == 4) {
// //       print(
// //           'Line Layer: ${coordinate[0]}, X: ${coordinate[1]}, Y: ${coordinate[2]}, Z: ${coordinate[3]}');
// //     }
// //   }
// // }
//
// //
// // import 'dart:io';
// //
// // class Coordinate {
// //   final double x;
// //   final double y;
// //   final double z;
// //
// //   Coordinate(this.x, this.y, this.z);
// //
// //   Coordinate copyWith({double? x, double? y, double? z}) {
// //     return Coordinate(x ?? this.x, y ?? this.y, z ?? this.z);
// //   }
// // }
// //
// // enum DXFCode {
// //   x10,
// //   y20,
// //   z30,
// //   x11,
// //   y21,
// //   z31,
// //   layer8, unknown,
// // }
// //
// // void main() {
// //   final file = File('file/test.dxf');
// //   final lines = file.readAsLinesSync();
// //   int entitiesIndex = lines.indexOf("ENTITIES");
// //   if (entitiesIndex == -1) {print('Секция ENTITIES не найдена.');
// //   return;
// //   }
// //
// //   List<Coordinate> coordinates = [];
// //   Coordinate? currentCoordinate;
// //   Coordinate? currentCoordinate2;
// //   String? currentLayer;
// //   bool readingCoordinatesLine = false;
// //   String currentCode = '';
// //
// //   for (int i = entitiesIndex + 2; i < lines.length; i++) {
// //     final line = lines[i].trim();
// //     if (line == 'ENDSEC') break;
// //     if (line == 'LINE') {
// //       readingCoordinatesLine = true;
// //     } else if (readingCoordinatesLine) {
// //       final code = int.tryParse(line);
// //       if (code != null) {
// //         currentCode = line;
// //       } else {
// //         final dxfCode = DXFCode.values.firstWhere(
// //               (e) => e.name.substring(1) == currentCode,
// //           orElse: () => DXFCode.unknown, // Возвращаем DXFCode.unknown, если код не найден
// //         );
// //
// //         if (dxfCode != DXFCode.unknown) {
// //           final value = double.tryParse(line);
// //           if (value != null) {
// //             switch (dxfCode){
// //               case DXFCode.x10:
// //                 currentCoordinate = Coordinate(value, 0, 0);
// //                 break;
// //               case DXFCode.y20:
// //                 currentCoordinate = currentCoordinate?.copyWith(y: value) ??
// //                     Coordinate(0, value, 0);
// //                 break;
// //               case DXFCode.z30:
// //                 currentCoordinate = currentCoordinate?.copyWith(z: value) ??
// //                     Coordinate(0, 0, value);
// //                 break;
// //               case DXFCode.x11:
// //                 currentCoordinate2 = Coordinate(value, 0, 0);
// //                 break;
// //               case DXFCode.y21:
// //                 currentCoordinate2 = currentCoordinate2?.copyWith(y: value) ??
// //                     Coordinate(0, value, 0);
// //                 break;
// //               case DXFCode.z31:
// //                 currentCoordinate2 = currentCoordinate2?.copyWith(z: value) ??
// //                     Coordinate(0, 0, value);
// //                 break;
// //               case DXFCode.layer8:
// //                 currentLayer = line;
// //                 break;
// //             }
// //           } else {
// //             // Обработка ошибки: не удалось преобразовать значение в число
// //             print("Ошибка: Не удалось преобразовать '$line' в число.");
// //           }
// //         }
// //       }
// //     } else if (line.trim() == '0' &&
// //         currentCoordinate != null &&
// //         currentCoordinate2 != null) {
// //       // Конец объекта LINE, выводим результат
// //       print(
// //           "Layer: $currentLayer, X: ${currentCoordinate.x}, Y: ${currentCoordinate.y}, Z: ${currentCoordinate.z}, X2: ${currentCoordinate2.x}, Y2: ${currentCoordinate2.y}, Z2: ${currentCoordinate2.z}");
// //       coordinates.add(currentCoordinate);
// //       currentCoordinate = null;
// //       currentCoordinate2 = null;
// //       currentLayer = null;
// //       readingCoordinatesLine = false;
// //     }
// //   }
// // }
//
// // import 'dart:io';
// //
// // class Coordinate {
// //   final double x;
// //   final double y;
// //   final double z;
// //
// //   Coordinate(this.x, this.y, this.z);
// //
// //   Coordinate copyWith({double? x, double? y, double? z}) {return Coordinate(x ?? this.x, y ?? this.y, z ?? this.z);
// //   }
// // }
// //
// // enum DXFCode {
// //   x(10),
// //   y(20),
// //   z(30),
// //   x2(11),
// //   y2(21),
// //   z2(31),
// //   layer(8),
// //   unknown(-1);
// //
// //   final int code;
// //   const DXFCode(this.code);
// // }
// //
// // void main() {
// //   final file = File('file/test.dxf');// Замените на путь к вашему файлу
// //   final lines = file.readAsLinesSync();
// //   int entitiesIndex = lines.indexOf("ENTITIES");
// //   if (entitiesIndex == -1) {
// //     print('Секция ENTITIES не найдена.');
// //     return;
// //   }
// //
// //   List<Coordinate> coordinates = [];
// //   Coordinate? currentCoordinate;
// //   Coordinate? currentCoordinate2;
// //   String? currentLayer;
// //   bool readingCoordinatesLine = false;
// //   String currentCode = '';
// //
// //   for (int i = entitiesIndex + 2; i < lines.length; i++) {
// //     final line = lines[i].trim();
// //     if (line == 'ENDSEC') break;
// //     if (line == 'LINE') {
// //       readingCoordinatesLine = true;
// //     } else if (readingCoordinatesLine) {
// //       final code = int.tryParse(line);
// //       if (code != null) {
// //         currentCode = line;
// //         // print('currentCode: $currentCode');
// //       } else {
// //         final dxfCode = DXFCode.values.firstWhere(
// //               (e) => e.code.toString() == currentCode, // Используем code для сравнения
// //           orElse: () => DXFCode.unknown,
// //         );
// //         if (dxfCode != DXFCode.unknown) {
// //           final value = double.tryParse(line);
// //           if (value != null) {
// //             switch (dxfCode) {
// //               case DXFCode.x:
// //                 currentCoordinate = Coordinate(value, 0, 0);
// //                 break;
// //               case DXFCode.y:
// //                 currentCoordinate =
// //                     currentCoordinate?.copyWith(y: value) ?? Coordinate(0, value, 0);
// //                 // print('Value: ${currentCoordinate.y}');
// //                 break;
// //               case DXFCode.z:
// //                 currentCoordinate =
// //                     currentCoordinate?.copyWith(z: value) ?? Coordinate(0, 0, value);
// //                 break;
// //               case DXFCode.x2:
// //                 currentCoordinate2 = Coordinate(value, 0, 0);
// //                 break;
// //               case DXFCode.y2:
// //                 currentCoordinate2 =
// //                     currentCoordinate2?.copyWith(y: value) ?? Coordinate(0, value, 0);
// //                 break;
// //               case DXFCode.z2:
// //                 currentCoordinate2 =
// //                     currentCoordinate2?.copyWith(z: value) ?? Coordinate(0, 0, value);
// //                 break;
// //               case DXFCode.layer:
// //                 currentLayer = line;
// //                 print("LAYER: $currentLayer");
// //                 break;
// //             // Случай DXFCode.unknown уже обработан в условии выше
// //               case DXFCode.unknown:
// //                 // TODO: Handle this case.
// //             }
// //           }
// //         }
// //       }
// //     } else if (line.trim() == '0' &&
// //         currentCoordinate != null &&
// //         currentCoordinate2 != null) {
// //       print(
// //           "Layer: $currentLayer, X: ${currentCoordinate.x}, Y: ${currentCoordinate.y}, Z: ${currentCoordinate.z}, X2: ${currentCoordinate2.x}, Y2: ${currentCoordinate2.y}, Z2: ${currentCoordinate2.z}");
// //       coordinates.add(currentCoordinate);
// //       readingCoordinatesLine = false;
// //     }
// //   }
// //   print("COOR: X: $coordinates");
// // }
//
//
// // import 'dart:io';
// //
// // class Coordinate {
// //   final double x;
// //   final double y;
// //   final double z;
// //
// //   Coordinate(this.x, this.y, this.z);
// //
// //   Coordinate copyWith({double? x, double? y, double? z}) {
// //     return Coordinate(x ?? this.x, y ?? this.y, z ?? this.z);
// //   }
// //
// //   @override
// //   String toString() => 'X: $x, Y: $y, Z: $z';
// // }
// //
// // enum DXFCode {
// //   x(10),
// //   y(20),
// //   z(30),
// //   x2(11),
// //   y2(21),
// //   z2(31),
// //   layer(8),
// //   unknown(-1);
// //
// //   final int code;
// //   const DXFCode(this.code);
// //
// //   static DXFCode fromCode(String code) {
// //     return DXFCode.values.firstWhere(
// //           (e) => e.code.toString() == code,
// //       orElse: () => DXFCode.unknown,
// //     );
// //   }
// // }
// //
// // void main() {
// //   final file = File('file/test.dxf'); // Замените на путь к вашему файлу
// //   final lines = file.readAsLinesSync();
// //   int entitiesIndex = lines.indexOf("ENTITIES");
// //   if (entitiesIndex == -1) {
// //     print('Секция ENTITIES не найдена.');
// //     return;
// //   }
// //
// //   List<Coordinate> coordinates = [];
// //   Coordinate? currentCoordinate;
// //   Coordinate? currentCoordinate2;
// //   String? currentLayer;
// //   bool isReadingLine = false;
// //   String currentCode = '';
// //
// //   for (int i = entitiesIndex + 2; i < lines.length; i++) {
// //     final line = lines[i].trim();
// //
// //     if (line == 'ENDSEC') break;
// //     if (line == 'LINE') {
// //       isReadingLine = true;
// //       continue;
// //     }
// //
// //     if (isReadingLine) {
// //       final code = int.tryParse(line);
// //       if (code != null) {
// //         currentCode = line;
// //       } else {
// //         final dxfCode = DXFCode.fromCode(currentCode);
// //         final value = double.tryParse(line);
// //
// //         if (value != null) {
// //           switch (dxfCode) {
// //             case DXFCode.x:
// //               currentCoordinate = Coordinate(value, 0, 0);
// //               break;
// //             case DXFCode.y:
// //               currentCoordinate = currentCoordinate?.copyWith(y: value) ?? Coordinate(0, value, 0);
// //               break;
// //             case DXFCode.z:
// //               currentCoordinate = currentCoordinate?.copyWith(z: value) ?? Coordinate(0, 0, value);
// //               break;
// //             case DXFCode.x2:
// //               currentCoordinate2 = Coordinate(value, 0, 0);
// //               break;
// //             case DXFCode.y2:
// //               currentCoordinate2 = currentCoordinate2?.copyWith(y: value) ?? Coordinate(0, value, 0);
// //               break;
// //             case DXFCode.z2:
// //               currentCoordinate2 = currentCoordinate2?.copyWith(z: value) ?? Coordinate(0, 0, value);
// //               break;
// //             case DXFCode.layer:
// //               currentLayer = line;
// //               print("LAYER: $currentLayer");
// //               break;
// //             case DXFCode.unknown:
// //               break;
// //           }
// //         }
// //       }
// //     }
// //
// //     if (line == '0' && currentCoordinate != null && currentCoordinate2 != null) {
// //       print(
// //           "Layer: $currentLayer, ${currentCoordinate.toString()}, ${currentCoordinate2.toString()}");
// //       coordinates.add(currentCoordinate);
// //       isReadingLine = false;
// //     }
// //   }
// // }
//
//
// import 'dart:io';
//
// class Coordinate {
//   final double x;
//   final double y;
//   final double z;
//
//   Coordinate(this.x, this.y, this.z);
//
//   Coordinate copyWith({double? x, double? y, double? z}) {
//     return Coordinate(x ?? this.x, y ?? this.y, z ?? this.z);
//   }
//
//   @override
//   String toString() => 'X: $x, Y: $y, Z: $z';
// }
//
// enum DXFCode {
//   x(10),
//   y(20),
//   z(30),
//   x2(11),
//   y2(21),
//   z2(31),
//   layer(8),
//   unknown(-1);
//
//   final int code;
//   const DXFCode(this.code);
//
//   static DXFCode fromCode(String code) {
//     return DXFCode.values.firstWhere(
//           (e) => e.code.toString() == code,
//       orElse: () => DXFCode.unknown,
//     );
//   }
// }
//
// void main() {
//   final file = File('file/test.dxf'); // Замените на путь к вашему файлу
//   final lines = file.readAsLinesSync();
//   int entitiesIndex = lines.indexOf("ENTITIES");
//   if (entitiesIndex == -1) {
//     print('Секция ENTITIES не найдена.');
//     return;
//   }
//
//   List<Coordinate> coordinates = [];
//   Coordinate? currentCoordinate;
//   Coordinate? currentCoordinate2;
//   String? currentLayer;
//   bool isReadingLine = false;
//   String currentCode = '';
//
//   for (int i = entitiesIndex + 2; i < lines.length; i++) {
//     final line = lines[i].trim();
//
//     if (line == 'ENDSEC') break;
//     if (line == 'LINE') {
//       isReadingLine = true;
//       continue;
//     }
//
//     if (isReadingLine) {
//       final code = int.tryParse(line);
//       if (code != null) {
//         currentCode = line;
//       } else {
//         final dxfCode = DXFCode.fromCode(currentCode);
//         final value = double.tryParse(line);
//
//         if (value != null || dxfCode == DXFCode.layer) {
//           switch (dxfCode) {
//             case DXFCode.x:
//               currentCoordinate = Coordinate(value!, 0, 0);
//               break;
//             case DXFCode.y:
//               currentCoordinate = currentCoordinate?.copyWith(y: value) ?? Coordinate(0, value!, 0);
//               break;
//             case DXFCode.z:
//               currentCoordinate = currentCoordinate?.copyWith(z: value) ?? Coordinate(0, 0, value!);
//               break;
//             case DXFCode.x2:
//               currentCoordinate2 = Coordinate(value!, 0, 0);
//               break;
//             case DXFCode.y2:
//               currentCoordinate2 = currentCoordinate2?.copyWith(y: value) ?? Coordinate(0, value!, 0);
//               break;
//             case DXFCode.z2:
//               currentCoordinate2 = currentCoordinate2?.copyWith(z: value) ?? Coordinate(0, 0, value!);
//               break;
//             case DXFCode.layer:
//               currentLayer = line;
//               break;
//             case DXFCode.unknown:
//               break;
//           }
//         }
//       }
//     }
//
//     if (line == '0' && currentCoordinate != null && currentCoordinate2 != null) {
//       print(
//           "Layer: $currentLayer, ${currentCoordinate.toString()}, ${currentCoordinate2.toString()}");
//       coordinates.add(currentCoordinate);
//       isReadingLine = false;
//       currentCoordinate = null;
//       currentCoordinate2 = null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

class Coordinate {
  final double x;
  final double y;
  final double z;

  Coordinate(this.x, this.y, this.z);

  Coordinate copyWith({double? x, double? y, double? z}) {
    return Coordinate(x ?? this.x, y ?? this.y, z ?? this.z);
  }

  @override
  String toString() => 'X: $x, Y: $y, Z: $z';
}

enum DXFCode {
  x(10),
  y(20),
  z(30),
  x2(11),
  y2(21),
  z2(31),
  layer(8),
  unknown(-1);

  final int code;

  const DXFCode(this.code);

  static DXFCode fromCode(String code) {
    return DXFCode.values.firstWhere(
      (e) => e.code.toString() == code,
      orElse: () => DXFCode.unknown,
    );
  }
}

void main() {
  final file = File('file/test.dxf');
  // final file = File('file/lira_color11.dxf');
  final outputFile1 = File('file/Result.txt');
  // final outputFile2 = File('output.acad.json');
  final outputFile = File('file/acad111.json');
  final lines = file.readAsLinesSync();
  int entitiesIndex = lines.indexOf("ENTITIES");
  if (entitiesIndex == -1) {
    print('Секция ENTITIES не найдена.');
    return;
  }

  List<Map<String, dynamic>> objects = [];
  List<Map<String, dynamic>>? layers = [];
  String? currentLayer;
  bool readingObject = false;
  String currentObjectType = '';
  Coordinate? currentCoordinate;
  Coordinate? currentCoordinate2;
  String currentCode = '';

  for (int i = entitiesIndex + 2; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line == 'ENDSEC') break;
    if (line == 'LINE' || line == 'POINT' || line == '3DFACE') {
      if (readingObject) {
        objects.add({
          "type": currentObjectType,
          "layer": currentLayer,
          "coordinates": [currentCoordinate, currentCoordinate2],
        });
      }

      readingObject = true;
      currentObjectType = line;
      currentLayer = null;
      currentCoordinate = null;
      currentCoordinate2 = null;
      continue;
    }

    if (readingObject) {
      final code = int.tryParse(line);
      if (code != null) {
        currentCode = line;
      } else {
        final dxfCode = DXFCode.fromCode(currentCode);
        final value = double.tryParse(line);
        if (value != null || dxfCode == DXFCode.layer) {
          switch (dxfCode) {
            case DXFCode.x:
              currentCoordinate = Coordinate(value!, 0, 0);
              break;
            case DXFCode.y:
              currentCoordinate = currentCoordinate?.copyWith(y: value) ??
                  Coordinate(0, value!, 0);
              break;
            case DXFCode.z:
              currentCoordinate = currentCoordinate?.copyWith(z: value) ??
                  Coordinate(0, 0, value!);
              break;
            case DXFCode.x2:
              currentCoordinate2 = Coordinate(value!, 0, 0);
              break;
            case DXFCode.y2:
              currentCoordinate2 = currentCoordinate2?.copyWith(y: value) ??
                  Coordinate(0, value!, 0);
              break;
            case DXFCode.z2:
              currentCoordinate2 = currentCoordinate2?.copyWith(z: value) ??
                  Coordinate(0, 0, value!);
              break;
            case DXFCode.layer:
              currentLayer = line;
              print('currentLayer: $currentLayer');
            case DXFCode.unknown:
              break;
          }
        }
      }
    }

    if (line == '0' && currentCoordinate != null) {
      currentCoordinate2 ??= currentCoordinate;

      objects.add({
        "type": currentObjectType,
        "layer": currentLayer,
        "coordinates": [currentCoordinate, currentCoordinate2],
      });

      readingObject = false;
    }
  }
  final sink = outputFile1.openWrite();
  for (final obj in objects) {
    final layer = obj["layer"];
    // if(layer != null){
      String output =
          '${obj["type"]}, Layer: ${obj["layer"]}, Coordinates: ${obj["coordinates"]}\n';
      sink.write(output);
    // }
  }
  sink.close();
  Map<String, dynamic> layersMap = {};

  for (var obj in objects) {
    final layer = obj["layer"];
    if (layer == null || layer == "default") {
      continue;
    }

    if (!layersMap.containsKey(layer)) {
      // if (layer != 'default') {
        print("Layer: $layer");
        layersMap[layer] = {
          "name": layer,
          "name_ord": layer.codeUnits, // Преобразование имени слоя в ASCII-коды
          "points": [],
          "lines": [],
          "faces": [],
          "texts": [],
          "tables": []
        };
      // }
      print("Layer: $layer");
    }

    List<List<double>> coordinates = [];
    for (var coord in obj['coordinates']) {
      coordinates.add([coord.x, coord.y, coord.z]);
    }

    if (obj['type'] == 'LINE') {
      layersMap[layer]['lines'].add(coordinates);
    } else if (obj['type'] == 'POINT') {
      layersMap[layer]['points'].add(coordinates);
    } else if (obj['type'] == '3DFACE') {
      layersMap[layer]['faces'].add(coordinates);
    }
  }

  layers = layersMap.values.cast<Map<String, dynamic>>().toList();

  Map<String, dynamic> acadJson = {
    "name": "X:${file.path}",
    "layers": layers,
  };

  outputFile.writeAsStringSync(jsonEncode(acadJson),
      mode: FileMode.write, flush: true);

  print('Данные успешно сохранены в формате JSON.');
}
