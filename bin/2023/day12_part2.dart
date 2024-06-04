// https://adventofcode.com/2023/day/12

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 12;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

List<int> springCount = [];
List<int> reqSpace = [];
String str = "";
Map<int, int> cache = {};

int nbValid(int idx, int idxList) {
  if (idx >= str.length) return (idxList >= springCount.length ? 1 : 0);
  if (idxList >= springCount.length) return (str.contains('#', idx) ? 0 : 1);
  if (str.length - idx < reqSpace[idxList]) return 0;
  int tmpResult = 0;
  switch (str[idx]) {
    case '.':
      while ((idx < str.length) && (str[idx] == '.')) idx++;
      return memoizeNbValid(idx, idxList);
    case '?':
      tmpResult = memoizeNbValid(idx + 1, idxList);
      continue caseSharp;
    caseSharp:
    case '#':
      for (int i = 1; i < springCount[idxList]; i++)
        if (str[idx + i] == '.') return tmpResult;
      idx += springCount[idxList];
      if ((idx < str.length) && (str[idx] == '#')) return tmpResult;
      return tmpResult + memoizeNbValid(idx + 1, idxList + 1);
  }
  return 0;
}

int memoizeNbValid(int idx, int idxList) {
  int key = idx * 100 + idxList;
  if (cache.containsKey(key)) {
    return cache[key]!;
  } else {
    var result = nbValid(idx, idxList);
    cache[key] = result;
    return result;
  }
}

int solution(List<String> lines) {
  int result = 0;
  for (int y = 0; y < lines.length; y++) {
    List<int> tmpSpringCount = [];
    // extracts the data. example: ???.### 1,1,3
    String tmpstr = RegExp(r'^(?<str>[.#?]+)').stringMatch(lines[y])!;
    for (final m in RegExp(r'\d+').allMatches(lines[y])) {
      int tmpCount = int.parse(m.group(0)!);
      tmpSpringCount.add(tmpCount);
    }
    springCount = [];
    str = "";
    for (int i = 0; i < 5; i++) {
      str += (i == 0 ? '' : '?') + tmpstr;
      springCount.addAll(tmpSpringCount);
    }
    // calculates the required space remaining
    reqSpace = [0];
    for (int y = springCount.length - 1; y >= 0; y--)
      reqSpace.insert(
          0,
          (y == springCount.length - 1
              ? springCount[y]
              : reqSpace[0] + springCount[y] + 1));
    if (debugMode) print('$str $springCount $reqSpace');
    // checks the valid configurations

    cache = {};
    result += memoizeNbValid(0, 0);
    // print(result);
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
      525152);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
