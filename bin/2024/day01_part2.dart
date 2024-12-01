// https://adventofcode.com/2024/day/1

import 'dart:core';
import 'dart:io';

const year = 2024;
const int day = 1;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> listStr) {
  List<int> left = [];
  Map<int, int> appearance = {};
  for (String str in listStr) {
    RegExpMatch? match =
        RegExp(r'^(?<left>\d+)   (?<right>\d+)').firstMatch(str);
    int l = int.parse(match!.namedGroup('left')!);
    int r = int.parse(match.namedGroup('right')!);
    left.add(l);
    appearance[r] = (appearance[r] == null ? 1 : appearance[r]! + 1);
  }
  int sum = 0;
  for (int l in left) {
    sum += l * (appearance[l] == null ? 0 : appearance[l]!);
  }
  return sum;
}

void main() {
  assert(debugMode = true);
  assert(solution([
        '3   4',
        '4   3',
        '2   5',
        '1   3',
        '3   9',
        '3   3',
      ]) ==
      31);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
