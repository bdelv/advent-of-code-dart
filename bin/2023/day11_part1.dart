import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 11;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Galaxy {
  int x;
  int y;
  Galaxy(this.x, this.y);
  @override
  String toString() => '$x,$y';
}

int solution(List<String> lines) {
  List<String> space = [];
  List<Galaxy> galaxies = [];
  int result = 0;
  // detect the empty columns
  String columns = ''.padRight(lines[0].length, '.');
  for (int x = 0; x < lines[0].length; x++) {
    for (int y = 0; y < lines.length; y++)
      if (lines[y][x] == '#') columns = columns.replaceRange(x, x + 1, '#');
  }
  // create the expanded space
  for (int y = 0; y < lines.length; y++) {
    String line = lines[y];
    for (int x = line.length - 1; x >= 0; x--) {
      if (columns[x] == '.')
        line = '${line.substring(0, x)}.${line.substring(x)}';
    }
    space.add(line);
    if (!line.contains("#")) space.add(line);
  }
  // list the galaxies and their coordinates
  for (int y = 0; y < space.length; y++) {
    int idx = -1;
    while ((idx = space[y].indexOf('#', idx + 1)) >= 0) {
      galaxies.add(Galaxy(idx, y));
    }
  }
  if (debugMode) print('galaxies: $galaxies');
  // calculate the shortest path
  for (int gal1 = 0; gal1 < galaxies.length - 1; gal1++)
    for (int gal2 = gal1 + 1; gal2 < galaxies.length; gal2++) {
      result += (galaxies[gal1].x - galaxies[gal2].x).abs() +
          (galaxies[gal1].y - galaxies[gal2].y).abs();
    }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
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
      ]) ==
      374);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
