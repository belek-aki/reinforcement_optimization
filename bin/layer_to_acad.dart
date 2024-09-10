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
  // final file = File('file/test.dxf');
  final file = File('file/lira_color11.dxf');
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

  Map<String, dynamic> layersMap = {};

  for (var obj in objects) {
    final layer = obj["layer"];
    if (layer == null || layer == "default") {
      continue;
    }

    if (!layersMap.containsKey(layer)) {
      layersMap[layer] = {
        "name": layer,
        "name_ord": layer.codeUnits, // Преобразование имени слоя в ASCII-коды
        "points": [],
        "lines": [],
        "faces": [],
        "texts": [],
        "tables": []
      };
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
