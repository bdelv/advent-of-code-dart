// https://adventofcode.com/2023/day/10

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 10;
const int part = 2;
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
List<String> cleanLines = [];

enum Direction { up, right, down, left, nowhere }

int solution(List<String> lines) {
  int result = 0;
  int startX = 0;
  int startY = 0;
  int sizeMaze(int startX, int startY) {
    int x = startX;
    int y = startY;
    int result = 0;
    Direction dir = Direction.nowhere;
    do {
      // print('$x,$y');
      // up
      if ((dir != Direction.down) &&
          mapBlocks[lines[y][x]]![0]![1] &&
          (y > 0) &&
          mapBlocks[lines[y - 1][x]]![2]![1]) {
        dir = Direction.up;
      } else
      // right
      if ((dir != Direction.left) &&
          mapBlocks[lines[y][x]]![1]![2] &&
          (x < lines[y].length - 1) &&
          mapBlocks[lines[y][x + 1]]![1]![0]) {
        dir = Direction.right;
      } else
      // down
      if ((dir != Direction.up) &&
          mapBlocks[lines[y][x]]![2]![1] &&
          (y < lines.length - 1) &&
          mapBlocks[lines[y + 1][x]]![0]![1]) {
        dir = Direction.down;
      } else
      // left
      if ((dir != Direction.right) &&
          mapBlocks[lines[y][x]]![1]![0] &&
          (x > 0) &&
          mapBlocks[lines[y][x - 1]]![1]![2]) {
        dir = Direction.left;
      } else
        return -1;
      // direction found
      cleanLines[y] = cleanLines[y].replaceRange(x, x + 1, lines[y][x]);
      result++;
      switch (dir) {
        case Direction.up:
          y--;
        case Direction.left:
          x--;
        case Direction.down:
          y++;
        case Direction.right:
          x++;
        default:
          return -1;
      }
    } while ((x != startX) || (y != startY));
    return result ~/ 2;
  }

  // search for S
  while (startY < lines.length) {
    startX = lines[startY].indexOf('S');
    if (startX >= 0) break;
    startY++;
  }
  // loop through the different pieces and search for the size of the loop (if it loops)
  for (String key in mapBlocks.keys) {
    lines[startY] = lines[startY].replaceRange(startX, startX + 1, key);
    cleanLines = [];
    for (int y = 0; y < lines.length; y++) {
      cleanLines.add(''.padRight(lines[y].length, '.'));
    }
    int tmpResult = sizeMaze(startX, startY);
    if (tmpResult > 0) {
      if (debugMode)
        for (int y = 0; y < cleanLines.length; y++) {
          print(cleanLines[y]);
        }
      for (int y = 0; y < cleanLines.length; y++) {
        bool inside = false;
        String prevChar = "";
        for (int x = 0; x < cleanLines[y].length; x++) {
          switch (cleanLines[y][x]) {
            case '.':
              if (inside) result++;
            case 'F' || 'L':
              prevChar = cleanLines[y][x];
            case '7':
              if (prevChar == 'L') inside = !inside;
            case 'J':
              if (prevChar == 'F') inside = !inside;
            case '|':
              inside = !inside;
          }
        }
        if (debugMode) print('$y: $result');
      }
    }
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '...........',
        '.S-------7.',
        '.|F-----7|.',
        '.||.....||.',
        '.||.....||.',
        '.|L-7.F-J|.',
        '.|..|.|..|.',
        '.L--J.L--J.',
        '...........',
      ]) ==
      4);
  assert(solution([
        '.F----7F7F7F7F-7....',
        '.|F--7||||||||FJ....',
        '.||.FJ||||||||L7....',
        'FJL7L7LJLJ||LJ.L-7..',
        'L--J.L7...LJS7F-7L7.',
        '....F-J..F7FJ|L7L7L7',
        '....L7.F7||L7|.L7L7|',
        '.....|FJLJ|FJ|F7|.LJ',
        '....FJL-7.||.||||...',
        '....L---J.LJ.LJLJ...',
      ]) ==
      8);
  assert(solution([
        'FF7FSF7F7F7F7F7F---7',
        'L|LJ||||||||||||F--J',
        'FL-7LJLJ||||||LJL-77',
        'F--JF--7||LJLJ7F7FJ-',
        'L---JF-JLJ.||-FJLJJ7',
        '|F|F-JF---7F7-L7L|7|',
        '|FFJF7L7F-JF7|JL---7',
        '7-L-JL7||F7|L7F-7F7|',
        'L.L7LFJ|||||FJL7||LJ',
        'L7JLJL-JLJLJL--JLJ.L',
      ]) ==
      10);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
