import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 3;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> doc) {
  if (debugMode) print('----------');
  int result = 0;
  for (int y = 0; y < doc.length; y++) {
    for (final m in RegExp(r'\d+').allMatches(doc[y])) {
      String around = "";
      int o1 = m.start - 1;
      int o2 = m.end + 1;
      if (m.start > 0)
        around += doc[y].substring(m.start - 1, m.start);
      else
        o1 = 0;
      if (m.end < doc[y].length)
        around += doc[y].substring(m.end, m.end + 1);
      else
        o2 = doc[y].length;
      if (y > 0) around += doc[y - 1].substring(o1, o2);
      if (y < doc.length - 1) around += doc[y + 1].substring(o1, o2);
      if (RegExp(r'^[.\d]+$').firstMatch(around) == null) {
        String val = m.group(0)!;
        if (debugMode) print(val);
        result += int.parse(val);
      }
    }
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '467..114..',
        '...*......',
        '..35..633.',
        '......#...',
        '617*......',
        '.....+.58.',
        '..592.....',
        '......755.',
        '...\$.*....',
        '.664.598..',
      ]) ==
      4361);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
