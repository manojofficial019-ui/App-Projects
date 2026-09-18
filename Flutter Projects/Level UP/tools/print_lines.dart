import 'dart:io';
void printRange(String path, int start, int end) {
  final lines = File(path).readAsLinesSync();
  for (var i = start; i <= end && i <= lines.length; i++) {
    print('${i.toString().padLeft(4)}: ${lines[i-1]}');
  }
}

void main() {
  final path = 'lib/main.dart';
  print('--- 240-265 ---');
  printRange(path, 240, 265);
  print('\n--- 568-585 ---');
  printRange(path, 568, 585);
}
