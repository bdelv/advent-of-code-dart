// https://adventofcode.com/2023/day/9

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 9;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  int result = 0;
  for (final String line in lines) {
    List<List<int>> values = [];
    values.add([]);
    for (final m in RegExp(r'-?\d+').allMatches(line)) {
      values[0].add(int.parse(m.group(0)!));
    }
    // fill the extra lines
    bool allZero = false;
    int y = 0;
    while (!allZero) {
      allZero = true;
      values.add([]);
      for (int x = 0; x < values[y].length - 1; x++) {
        values[y + 1].add(values[y][x + 1] - values[y][x]);
        if (values[y + 1][x] != 0) allZero = false;
      }
      y++;
    }
    // calculate the previous value
    values[values.length - 1].insert(0, 0);
    for (int y = values.length - 2; y >= 0; y--) {
      values[y].insert(0, values[y][0] - values[y + 1][0]);
    }
    result += values[0][0];
    if (debugMode) print(values);
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '0 3 6 9 12 15',
        '1 3 6 10 15 21',
        '10 13 16 21 30 45',
      ]) ==
      2);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
