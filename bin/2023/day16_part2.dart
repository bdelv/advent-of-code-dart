// https://adventofcode.com/2023/day/16

import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'dart:math';

const year = 2023;
const int day = 16;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  int calcEnergized(int x, int y, int dirx, int diry) {
    HashMap<int, int> cache = HashMap<int, int>();
    List<List<bool>> energized = [];
    for (int y = 0; y < lines.length; y++) {
      energized.add([]);
      for (int x = 0; x < lines[y].length; x++) {
        energized[y].add(false);
      }
    }
    void beam(int x, int y, int dirx, int diry) {
      while (true) {
        x += dirx;
        y += diry;
        if ((y < 0) || (y >= lines.length) || (x < 0) || (x >= lines[y].length)) {
          break;
        }
        int hash = x * 100000 + y * 100 + dirx * 10 + diry;
        if (cache.containsKey(hash)) break;
        cache[hash] = 0;
        energized[y][x] = true;
        // print("$x,$y $dirx,$diry");
        switch (lines[y][x]) {
          case "\\":
            (dirx, diry) = (diry, dirx);
            break;
          case "/":
            (dirx, diry) = (-diry, -dirx);
            break;
          case "|":
            if (diry == 0) {
              beam(x, y, 0, -1);
              (dirx, diry) = (0, 1);
            }
            break;
          case "-":
            if (dirx == 0) {
              beam(x, y, -1, 0);
              (dirx, diry) = (1, 0);
            }
            break;
        }
      }
    }

    beam(x, y, dirx, diry);
    int result = 0;
    for (int y = 0; y < lines.length; y++)
      for (int x = 0; x < lines[y].length; x++) {
        if (energized[y][x]) result++;
      }
    if (debugMode) print("$x,$y $dirx,$diry $result");
    return result;
  }

  int result = 0;
  for (int y = 0; y < lines.length; y++) {
    result = max(result, calcEnergized(-1, y, 1, 0));
    result = max(result, calcEnergized(lines[0].length, y, -1, 0));
  }
  for (int x = 0; x < lines[0].length; x++) {
    result = max(result, calcEnergized(x, -1, 0, 1));
    result = max(result, calcEnergized(x, lines.length, 0, -1));
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '.|...\\....',
        '|.-.\\.....',
        '.....|-...',
        '........|.',
        '..........',
        '.........\\',
        '..../.\\\\..',
        '.-.-/..|..',
        '.|....-|.\\',
        '..//.|....',
      ]) ==
      51);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
