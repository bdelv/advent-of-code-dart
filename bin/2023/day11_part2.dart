import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 11;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Galaxy {
  int x;
  int y;
  Galaxy(this.x, this.y);
  @override
  String toString() => '$x,$y';
}

int solution(List<String> lines, int emptySize) {
  List<String> space = [];
  List<Galaxy> galaxies = [];
  int result = 0;
  // detect the empty columns
  String columns = ''.padRight(lines[0].length, '0');
  for (int x = 0; x < lines[0].length; x++) {
    for (int y = 0; y < lines.length; y++)
      if (lines[y][x] == '#') columns = columns.replaceRange(x, x + 1, '#');
  }
  // create the space with marked empty lines and columns (0 = empty)
  for (int y = 0; y < lines.length; y++) {
    String line = lines[y];
    for (int x = 0; x < lines[0].length; x++)
      if (columns[x] == '0') line = line.replaceRange(x, x + 1, '0');
    if (!line.contains("#")) line = ''.padRight(line.length, '0');
    space.add(line);
  }
  // print(space);
  // list the galaxies and their coordinates
  for (int y = 0; y < space.length; y++) {
    int idx = -1;
    while ((idx = space[y].indexOf('#', idx + 1)) >= 0) {
      galaxies.add(Galaxy(idx, y));
    }
  }
  if (debugMode) print('galaxies: $galaxies');
  // calculate the shortest path between each pairs
  for (int gal1 = 0; gal1 < galaxies.length - 1; gal1++)
    for (int gal2 = gal1 + 1; gal2 < galaxies.length; gal2++) {
      int distance = 0;
      int deltaY = (galaxies[gal2].y - galaxies[gal1].y).sign;
      for (int y = galaxies[gal1].y; y != galaxies[gal2].y; y += deltaY) {
        distance +=
            (space[y + deltaY][galaxies[gal1].x] == '0' ? emptySize : 1);
      }
      int deltaX = (galaxies[gal2].x - galaxies[gal1].x).sign;
      for (int x = galaxies[gal1].x; x != galaxies[gal2].x; x += deltaX) {
        distance +=
            (space[galaxies[gal1].y][x + deltaX] == '0' ? emptySize : 1);
      }
      result += distance;
    }
  return result;
}

void main() {
  assert(debugMode = true);

  List<String> inputTest = [
    '...#......',
    '.......#..',
    '#.........',
    '..........',
    '......#...',
    '.#........',
    '.........#',
    '..........',
    '.......#..',
    '#...#.....',
  ];
  assert(solution(inputTest, 2) == 374);
  assert(solution(inputTest, 10) == 1030);
  assert(solution(inputTest, 100) == 8410);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input, 1000000)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
