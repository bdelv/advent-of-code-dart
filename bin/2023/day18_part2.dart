// https://adventofcode.com/2023/day/18

import 'dart:core';
import 'dart:io';
import 'dart:math';

const year = 2023;
const int day = 18;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Vector {
  int x;
  int y;
  Vector(this.x, this.y);
}

int solution(List<String> lines) {
  // generate the array describing the yard
  int x = 0;
  int y = 0;
  List<Vector> vects = [Vector(x, y)];
  List<String> dirs = ['R', 'D', 'L', 'U'];
  for (int line = 0; line < lines.length; line++) {
    RegExpMatch? match = RegExp(r'^(?<dir>\w) (?<nb>\d+) \(\#(?<color>\w+)\)$')
        .firstMatch(lines[line]);
    String dir = match!.namedGroup('dir')!;
    int nb = int.parse(match.namedGroup('nb')!);
    String color = match.namedGroup('color')!;

    dir = dirs[int.parse(color[5])];
    nb = int.parse(color.substring(0, 5), radix: 16);
    if (debugMode) print('$dir $nb $color');

    switch (dir) {
      case 'U':
        y -= nb;
        break;
      case 'D':
        y += nb;
        break;
      case 'L':
        x -= nb;
        break;
      case 'R':
        x += nb;
        break;
    }
    vects.add(Vector(x, y));
  }
  // area: Shoelace algo
  int area = 0;
  for (int i = 1; i < vects.length; i++) {
    area += vects[i - 1].y * vects[i].x - vects[i - 1].x * vects[i].y;
  }
  area = (area ~/ 2).abs();
  // Perimeter: sum of edge lengths
  int perimeter = 0;
  for (int i = 1; i < vects.length; i++)
    perimeter += sqrt(pow(vects[i].x - vects[i - 1].x, 2) +
            pow(vects[i].y - vects[i - 1].y, 2))
        .toInt();
  // pick's theorem (how many integer points within and on the shape's boundary)
  int result = area + perimeter ~/ 2 + 1;
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'R 6 (#70c710)',
        'D 5 (#0dc571)',
        'L 2 (#5713f0)',
        'D 2 (#d2c081)',
        'R 2 (#59c680)',
        'D 2 (#411b91)',
        'L 5 (#8ceee2)',
        'U 2 (#caa173)',
        'L 1 (#1b58a2)',
        'U 2 (#caa171)',
        'R 2 (#7807d2)',
        'U 3 (#a77fa3)',
        'L 2 (#015232)',
        'U 2 (#7a21e3)',
      ]) ==
      952408144115);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
