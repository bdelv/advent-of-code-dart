// https://adventofcode.com/2023/day/2

import 'dart:core';
import 'dart:io';
import 'dart:math';

const year = 2023;
const int day = 2;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> listStr, int nbRed, int nbGreen, int nbBlue) {
  int result = 0;
  for (int iline = 0; iline < listStr.length; iline++) {
    int shownBlue = 0;
    int shownRed = 0;
    int shownGreen = 0;
    String str = listStr[iline];
    RegExpMatch? match = RegExp(r'Game (?<ID>\d+).*').firstMatch(str);
    int id = int.parse(match?.namedGroup('ID') ?? "0");
    // Note: namedGroup doesn't work with r'[:;]( ((?<blue>\d+) blue|(?<red>\d+) red|(?<green>\d+) green),*)+'
    for (final m
        in RegExp(r'[:;]( (\d+ blue|\d+ red|\d+ green),*)+').allMatches(str)) {
      RegExpMatch? match;
      match = RegExp(r'(?<blue>\d+) blue').firstMatch(m.group(0)!);
      shownBlue = max(int.parse(match?.namedGroup('blue') ?? "0"), shownBlue);
      match = RegExp(r'(?<red>\d+) red').firstMatch(m.group(0)!);
      shownRed = max(int.parse(match?.namedGroup('red') ?? "0"), shownRed);
      match = RegExp(r'(?<green>\d+) green').firstMatch(m.group(0)!);
      shownGreen =
          max(int.parse(match?.namedGroup('green') ?? "0"), shownGreen);
    }
    if (debugMode) {
      print('ID:$id red:$shownRed green:$shownGreen blue:$shownBlue');
    }
    if ((shownBlue <= nbBlue) &&
        (shownRed <= nbRed) &&
        (shownGreen <= nbGreen)) {
      if (debugMode) print('-> match');
      result += id;
    }
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
        'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
        'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
        'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
        'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',
      ], 12, 13, 14) ==
      8);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input, 12, 13, 14)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
