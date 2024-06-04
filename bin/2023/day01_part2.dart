// https://adventofcode.com/2023/day/1

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 1;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

Map<String, int> writtenDigits = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
  "0": 0,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
};

int solution(List<String> listStr) {
  int total = 0;
  for (int iline = 0; iline < listStr.length; iline++) {
    String str = listStr[iline];
    if (debugMode) print(str);
    int result = 0;
    // Search for start
    bool found = false;
    for (int i = 0; i < str.length; i++) {
      for (String key in writtenDigits.keys) {
        if (str.startsWith(key, i)) {
          result += (writtenDigits[key] ?? 0) * 10;
          found = true;
          break;
        }
      }
      if (found) break;
    }
    // search for end
    found = false;
    for (int i = str.length - 1; i >= 0; i--) {
      for (String key in writtenDigits.keys) {
        if (str.substring(0, i + 1).endsWith(key)) {
          result += writtenDigits[key] ?? 0;
          found = true;
          break;
        }
      }
      if (found) break;
    }
    if (debugMode) print(result);
    total += result;
  }
  return total;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'two1nine',
        'eightwothree',
        'abcone2threexyz',
        'xtwone3four',
        '4nineeightseven2',
        'zoneight234',
        '7pqrstsixteen',
      ]) ==
      281);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
