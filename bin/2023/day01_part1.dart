// https://adventofcode.com/2023/day/1

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 1;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> listStr) {
  int total = 0;
  for (int iline = 0; iline < listStr.length; iline++) {
    String str = listStr[iline];
    if (debugMode) print("--- $str");
    int result = 0;
    for (int i = 0; i < str.length; i++) {
      if (str[i].contains(RegExp(r'[0-9]'))) {
        if (debugMode) print(int.parse(str[i]) * 10);
        result += int.parse(str[i]) * 10;
        break;
      }
    }
    for (int i = str.length - 1; i >= 0; i--) {
      if (str[i].contains(RegExp(r'[0-9]'))) {
        if (debugMode) print(int.parse(str[i]));
        result += int.parse(str[i]);
        break;
      }
    }
    total += result;
  }
  return total;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '1abc2',
        'pqr3stu8vwx',
        'a1b2c3d4e5f',
        'treb7uchet',
      ]) ==
      142);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
