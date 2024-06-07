// https://adventofcode.com/2023/day/14

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 14;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  int result = 0;
  if (debugMode) {
    print("-------");
    for (int y = 0; y < lines.length; y++) {
      print(lines[y]);
    }
    print("-------");
  }
  // for each column
  for (int x = 0; x < lines[0].length; x++) {
    int y = 0;
    int lastRock = -1;
    while (y < lines.length) {
      if (lines[y][x] == 'O') {
        lastRock++;
        if (lastRock != y) {
          lines[lastRock] = lines[lastRock].replaceRange(x, x + 1, 'O');
          lines[y] = lines[y].replaceRange(x, x + 1, '.');
        }
        result += lines.length - lastRock;
      }
      if (lines[y][x] == '#') {
        lastRock = y;
      }
      y++;
    }
  }
  if (debugMode) {
    for (int y = 0; y < lines.length; y++) {
      print(lines[y]);
    }
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'O....#....',
        'O.OO#....#',
        '.....##...',
        'OO.#O....O',
        '.O.....O#.',
        'O.#..O.#.#',
        '..O..#O..O',
        '.......O..',
        '#....###..',
        '#OO..#....',
      ]) ==
      136);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
