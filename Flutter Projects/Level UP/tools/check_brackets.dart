import 'dart:io';

void main() {
  final path = 'lib/main.dart';
  final text = File(path).readAsStringSync();
  final stack = <MapEntry<String,int>>[];

  for (var i = 0; i < text.length; i++) {
    final ch = text[i];
    final line = '\n'.allMatches(text.substring(0, i)).length + 1;
    if (ch == '(' || ch == '{' || ch == '[') stack.add(MapEntry(ch, line));
    if (ch == ')' || ch == '}' || ch == ']') {
      if (stack.isEmpty) {
        print('Unmatched closing $ch at line $line');
        exit(1);
      }
      final last = stack.removeLast();
      if ((last.key == '(' && ch != ')') ||
          (last.key == '{' && ch != '}') ||
          (last.key == '[' && ch != ']')) {
        print('Mismatched $ch at line $line, expected matching for ${last.key} from line ${last.value}');
        exit(1);
      }
    }
  }
  if (stack.isNotEmpty) {
    for (var e in stack) print('Unclosed ${e.key} opened at line ${e.value}');
    exit(1);
  }
  print('All brackets balanced');
}
