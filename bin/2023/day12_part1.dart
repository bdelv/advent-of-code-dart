// https://adventofcode.com/2023/day/12

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 12;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

List<int> springCount = [];
int sumCount = 0;

bool isValid(String springs) {
  String strExp = "^\\.*";
  for (int i = 0; i < springCount.length; i++) {
    // builds something like: ^\.*\#{2}.+\#{1}\.+\#{3}\.*$ for [2,1,3]
    strExp += "\\#{${springCount[i]}}";
    strExp += (i < springCount.length - 1 ? "\\.+" : "\\.*\$");
  }
  // if (debugMode) print('$springs, $strExp ${RegExp(strExp).hasMatch(springs)}');
  return RegExp(strExp).hasMatch(springs);
}

int nbValid(String springs) {
  int idx = springs.indexOf('?');
  if (idx < 0) return (isValid(springs) ? 1 : 0);
  return nbValid(springs.replaceRange(idx, idx + 1, '.')) +
      nbValid(springs.replaceRange(idx, idx + 1, '#'));
}

int solution(List<String> lines) {
  int result = 0;
  for (int y = 0; y < lines.length; y++) {
    springCount = [];
    sumCount = 0;
    // extracts the data. example: ???.### 1,1,3
    String str = RegExp(r'^(?<str>[.#?]+)').stringMatch(lines[y])!;
    for (final m in RegExp(r'\d+').allMatches(lines[y])) {
      int tmpCount = int.parse(m.group(0)!);
      springCount.add(tmpCount);
      sumCount += tmpCount;
    }
    // checks the valid configurations
    int tmpNb = nbValid(str);
    if (debugMode) print('$str $tmpNb');
    result += tmpNb;
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '???.### 1,1,3',
        '.??..??...?##. 1,1,3',
        '?#?#?#?#?#?#?#? 1,3,1,6',
        '????.#...#... 4,1,1',
        '????.######..#####. 1,6,5',
        '?###???????? 3,2,1',
      ]) ==
      21);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
