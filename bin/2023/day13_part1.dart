// https://adventofcode.com/2023/day/13

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 13;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int searchMirror(List<String> lines) {
  if (debugMode) for (int y = 0; y < lines.length; y++) print(lines[y]);
  // search vertical mirror
  bool different = false;
  int xMirror = 0;
  // Checks all potential vertical mirror centers
  for (int x = 0; x < lines[0].length - 1; x++) {
    int x1 = x + 1;
    int x2 = x;
    different = false;
    while (!different && (x1 > 0) && (x2 < lines[0].length - 1)) {
      x1--;
      x2++;
      // Checks all the lines if it is a mirror
      for (int tmpy = 0; tmpy < lines.length; tmpy++) {
        if (lines[tmpy][x1] != lines[tmpy][x2]) {
          different = true;
          break;
        }
      }
    }
    if (!different) {
      xMirror = x + 1;
      break;
    }
  }
  if (!different) {
    if (debugMode) print('x $xMirror');
    return xMirror;
  }
  // search horizontal mirror
  int yMirror = 0;
  for (int y = 0; y < lines.length - 1; y++) {
    int y1 = y + 1;
    int y2 = y;
    different = false;
    while (!different && (y1 > 0) && (y2 < lines.length - 1)) {
      y1--;
      y2++;
      // Checks all the lines if it is a mirror
      for (int tmpx = 0; tmpx < lines[0].length; tmpx++) {
        if (lines[y1][tmpx] != lines[y2][tmpx]) {
          different = true;
          break;
        }
      }
    }
    if (!different) {
      yMirror = y + 1;
      break;
    }
  }
  if (!different) {
    if (debugMode) print('y $yMirror');
    return yMirror * 100;
  }
  return 0;
}

int solution(List<String> lines) {
  int result = 0;
  List<String> form = [];
  for (int y = 0; y < lines.length; y++) {
    if (lines[y] != '') form.add(lines[y]);
    if ((y == lines.length - 1) || (lines[y] == '')) {
      result += searchMirror(form);
      form = [];
    }
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '#.##..##.',
        '..#.##.#.',
        '##......#',
        '##......#',
        '..#.##.#.',
        '..##..##.',
        '#.#.##.#.',
        '',
        '#...##..#',
        '#....#..#',
        '..##..###',
        '#####.##.',
        '#####.##.',
        '..##..###',
        '#....#..#',
      ]) ==
      405);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
