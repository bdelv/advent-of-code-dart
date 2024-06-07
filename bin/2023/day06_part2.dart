// https://adventofcode.com/2023/day/6

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 6;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  List<int> times = [];
  List<int> distances = [];
  int result = 0;

  // extract the data
  int y = 0;
  String timeStr = "";
  String distanceStr = "";
  for (final m in RegExp(r'\d+').allMatches(lines[y++])) {
    timeStr += m.group(0)!;
  }
  times.add(int.parse(timeStr));
  if (debugMode) print('times:$times');
  for (final m in RegExp(r'\d+').allMatches(lines[y++])) {
    distanceStr += m.group(0)!;
  }
  distances.add(int.parse(distanceStr));
  if (debugMode) print('distances:$distances');
  // Count the solutions
  for (int race = 0; race < times.length; race++) {
    int nbSolutions = 0;
    for (int i = 1; i < times[race]; i++) {
      if ((times[race] - i) * i > distances[race]) nbSolutions++;
    }
    if (nbSolutions > 0) {
      if (debugMode) print('race:$race sol:$nbSolutions');
      result = (result == 0 ? nbSolutions : result * nbSolutions);
    }
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'Time:      7  15   30',
        'Distance:  9  40  200',
      ]) ==
      71503);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
