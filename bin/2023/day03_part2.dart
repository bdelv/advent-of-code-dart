// https://adventofcode.com/2023/day/3

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 3;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Part {
  int value = -1;
  int x1 = -1;
  int x2 = -1;
  Part(this.value, this.x1, this.x2);
  @override
  String toString() {
    return "value: $value x1:$x1 x2:$x2";
  }
}

int solution(List<String> doc) {
  List<List<Part>> partsList = [];
  if (debugMode) print('----------');
  // extract the positions of every numbers
  for (int y = 0; y < doc.length; y++) {
    List<Part> partsLine = [];
    partsList.add(partsLine);
    for (final m in RegExp(r'\d+').allMatches(doc[y]))
      partsList[y].add(Part(int.parse(m.group(0)!), m.start, m.end));
  }
  if (debugMode) print(partsList);
  int result = 0;
  // scan for gears and check if there are numbers around (-1 +1)
  for (int y = 0; y < doc.length; y++) {
    for (final m in RegExp(r'\*').allMatches(doc[y])) {
      int tmpResult = 0;
      int nbFound = 0;
      int yy1 = (y == 0 ? 0 : y - 1);
      int yy2 = (y > doc.length - 1 ? doc.length - 1 : y + 1);
      for (int yLoop = yy1; yLoop <= yy2; yLoop++) {
        for (Part part in partsList[yLoop]) {
          if ((part.x1 <= m.end) && (part.x2 >= m.start)) {
            tmpResult = (tmpResult == 0 ? part.value : tmpResult * part.value);
            nbFound++;
            if (debugMode) print(part.value);
          }
        }
      }
      if (nbFound == 2) result += tmpResult;
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
      467835);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
