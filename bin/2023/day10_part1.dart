import 'dart:core';
import 'dart:io';
import 'dart:math';

const year = 2023;
const int day = 10;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

// | is a vertical pipe connecting north and south.
// - is a horizontal pipe connecting east and west.
// L is a 90-degree bend connecting north and east.
// J is a 90-degree bend connecting north and west.
// 7 is a 90-degree bend connecting south and west.
// F is a 90-degree bend connecting south and east.
// . is ground; there is no pipe in this tile.
// S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

Map<String, List<List<bool>?>> mapBlocks = {
  '|': [
    [false, true, false],
    [false, true, false],
    [false, true, false]
  ],
  '-': [
    [false, false, false],
    [true, true, true],
    [false, false, false]
  ],
  'L': [
    [false, true, false],
    [false, true, true],
    [false, false, false]
  ],
  'J': [
    [false, true, false],
    [true, true, false],
    [false, false, false]
  ],
  '7': [
    [false, false, false],
    [true, true, false],
    [false, true, false]
  ],
  'F': [
    [false, false, false],
    [false, true, true],
    [false, true, false]
  ],
  '.': [
    [false, false, false],
    [false, true, false],
    [false, false, false]
  ]
};

enum Direction { up, right, down, left, nowhere }

int solution(List<String> lines) {
  int result = 0;
  int startX = 0;
  int startY = 0;
  int sizeMaze(int startX, int startY) {
    int x = startX;
    int y = startY;
    int result = 0;
    Direction comingFrom = Direction.nowhere;
    do {
      String char = lines[y][x];
      // up
      if ((comingFrom != Direction.up) &&
          mapBlocks[char]![0]![1] &&
          (y > 0) &&
          mapBlocks[lines[y - 1][x]]![2]![1]) {
        comingFrom = Direction.down;
        y--;
        result++;
      } else
      // right
      if ((comingFrom != Direction.right) &&
          mapBlocks[char]![1]![2] &&
          (x < lines[y].length - 1) &&
          mapBlocks[lines[y][x + 1]]![1]![0]) {
        comingFrom = Direction.left;
        result++;
        x++;
      } else
      // down
      if ((comingFrom != Direction.down) &&
          mapBlocks[char]![2]![1] &&
          (y < lines.length - 1) &&
          mapBlocks[lines[y + 1][x]]![0]![1]) {
        comingFrom = Direction.up;
        result++;
        y++;
      } else
      // left
      if ((comingFrom != Direction.left) &&
          mapBlocks[char]![1]![0] &&
          (x > 0) &&
          mapBlocks[lines[y][x - 1]]![1]![2]) {
        comingFrom = Direction.right;
        x--;
        result++;
      } else
        return -1;
    } while ((x != startX) || (y != startY));
    return result ~/ 2;
  }

  // search for S
  while (startY < lines.length) {
    startX = lines[startY].indexOf('S');
    if (startX >= 0) break;
    startY++;
  }
  if (debugMode) print('Start: $startX,$startY');
  // loop through the different pieces and search for the size of the loop (if it loops)
  for (String key in mapBlocks.keys) {
    lines[startY] = lines[startY].replaceRange(startX, startX + 1, key);
    result = max(result, sizeMaze(startX, startY));
  }
  if (debugMode) print(lines);
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '.....',
        '.S-7.',
        '.|.|.',
        '.L-J.',
        '.....',
      ]) ==
      4);
  assert(solution([
        '..F7.',
        '.FJ|.',
        'SJ.L7',
        '|F--J',
        'LJ...',
      ]) ==
      8);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
