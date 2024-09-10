import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('file/Drawing3dFace3.dxf');
  final lines = file.readAsLinesSync();


  List<Map<String, double>> vertices = [];

  bool is3DFaceSection = false;
  Map<String, double> currentFaceVertices = {};
  int vertexCount = 0;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    print('File: $line');
    if (line == "0") {
      if (i + 1 < lines.length && lines[i + 1].trim() == "3DFACE") {
        is3DFaceSection = true;
        currentFaceVertices = {};
        vertexCount = 0;
        i++; // Пропустить следующий элемент, так как мы уже знаем, что это 3DFACE
      } else {
        is3DFaceSection = false;
      }
    }

    if (is3DFaceSection) {
      if (line == "10" ||
          line == "20" ||
          line == "30" ||
          line == "11" ||
          line == "21" ||
          line == "31" ||
          line == "12" ||
          line == "22" ||
          line == "32" ||
          line == "13" ||
          line == "23" ||
          line == "33") {
        double value = double.parse(lines[++i].trim());
        if (line == "10" || line == "11" || line == "12" || line == "13") {
          currentFaceVertices["x$vertexCount"] = value;
        } else if (line == "20" ||
            line == "21" ||
            line == "22" ||
            line == "23") {
          currentFaceVertices["y$vertexCount"] = value;
        } else if (line == "30" ||
            line == "31" ||
            line == "32" ||
            line == "33") {
          currentFaceVertices["z$vertexCount"] = value;
        }
        if (line == "13" || line == "23" || line == "33") {
          vertexCount++;
        }
      }
      if (vertexCount == 4) {
        vertices.add(Map.from(currentFaceVertices));
        vertexCount = 0;
        currentFaceVertices = {};
        is3DFaceSection = false;
      }
    }
  }

  // Сохранение данных в JSON файл
  final jsonFile = File('file/parsing.json');
  final jsonString = jsonEncode(vertices);
  jsonFile.writeAsStringSync(jsonString);

  print('3DFace данные сохранены в формате JSON');
}
