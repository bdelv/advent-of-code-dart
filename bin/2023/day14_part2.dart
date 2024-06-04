// https://adventofcode.com/2023/day/14

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 14;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines, int cycles) {
  void tilt(String dir) {
    switch (dir) {
      case 'N':
        for (int x = 0; x < lines[0].length; x++) {
          int lastRock = -1;
          for (int y = 0; y < lines.length; y++) {
            if (lines[y][x] == 'O') {
              lastRock++;
              if (lastRock != y) {
                lines[y] = lines[y].replaceRange(x, x + 1, '.');
                lines[lastRock] = lines[lastRock].replaceRange(x, x + 1, 'O');
              }
            } else if (lines[y][x] == '#') lastRock = y;
          }
        }
        break;
      case 'S':
        for (int x = 0; x < lines[0].length; x++) {
          int lastRock = lines.length;
          for (int y = lines.length - 1; y >= 0; y--) {
            if (lines[y][x] == 'O') {
              lastRock--;
              if (lastRock != y) {
                lines[y] = lines[y].replaceRange(x, x + 1, '.');
                lines[lastRock] = lines[lastRock].replaceRange(x, x + 1, 'O');
              }
            } else if (lines[y][x] == '#') lastRock = y;
          }
        }
        break;
      case 'W':
        for (int y = 0; y < lines.length; y++) {
          int lastRock = -1;
          for (int x = 0; x < lines[y].length; x++) {
            if (lines[y][x] == 'O') {
              lastRock++;
              if (lastRock != x) {
                lines[y] = lines[y].replaceRange(x, x + 1, '.');
                lines[y] = lines[y].replaceRange(lastRock, lastRock + 1, 'O');
              }
            } else if (lines[y][x] == '#') lastRock = x;
          }
        }
        break;
      case 'E':
        for (int y = 0; y < lines.length; y++) {
          int lastRock = lines[y].length;
          for (int x = lines[y].length - 1; x >= 0; x--) {
            if (lines[y][x] == 'O') {
              lastRock--;
              if (lastRock != x) {
                lines[y] = lines[y].replaceRange(x, x + 1, '.');
                lines[y] = lines[y].replaceRange(lastRock, lastRock + 1, 'O');
              }
            } else if (lines[y][x] == '#') lastRock = x;
          }
        }
        break;
    }
    if (debugMode) {
      print("--");
      for (int y = 0; y < lines.length; y++) print(lines[y]);
    }
  }

  // calculates the total load on the north support beams
  int calcNorthLoad() {
    int load = 0;
    for (int x = 0; x < lines[0].length; x++)
      for (int y = 0; y < lines.length; y++)
        if (lines[y][x] == 'O') load += lines.length - y;
    return load;
  }

  Map<String, int> cache = {};
  int cycle = 0;
  while (cycle < cycles) {
    tilt('N');
    tilt('W');
    tilt('S');
    tilt('E');
    int? prev = cache[lines.join()];
    if (prev == null)
      cache[lines.join()] = cycle;
    else
      cycle += ((cycles - cycle) ~/ (cycle - prev)) * (cycle - prev);
    cycle++;
  }
  return calcNorthLoad();
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
      ], 1) ==
      87);
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
      ], 1000000000) ==
      64);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input, 1000000000)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
