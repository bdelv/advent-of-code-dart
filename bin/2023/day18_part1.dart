import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 18;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  List<List<String>> lagoon = [
    [' ']
  ];

  // void printLagoon(List<List<String>> lagoon) {
  //   for (int y = 0; y < lagoon.length; y++) {
  //     String line = "";
  //     for (int x = 0; x < lagoon[y].length; x++)
  //       // line += (lagoon[y][x] == ' ') ? ' ' : '#';
  //       line += lagoon[y][x];
  //     print(line);
  //   }
  // }

  // generate the array describing the yard
  int x = 0;
  int y = 0;
  for (int line = 0; line < lines.length; line++) {
    RegExpMatch? match = RegExp(r'^(?<dir>\w) (?<nb>\d+) \(\#(?<color>\w+)\)$')
        .firstMatch(lines[line]);
    String dir = match!.namedGroup('dir')!;
    int nb = int.parse(match.namedGroup('nb')!);
    // String color = match!.namedGroup('color')!;
    // print('$dir $nb $color');

    switch (dir) {
      case 'U':
        lagoon[y][x] = 'U';
        for (int i = 0; i < nb; i++) {
          y--;
          if (y < 0) {
            lagoon.insert(
                0, List<String>.generate(lagoon[0].length, (int x) => ' '));
            y = 0;
          }
          lagoon[y][x] = 'U';
        }
        break;
      case 'D':
        lagoon[y][x] = 'D';
        for (int i = 0; i < nb; i++) {
          y++;
          if (y >= lagoon.length)
            lagoon.add(List<String>.generate(lagoon[0].length, (int i) => ' '));
          lagoon[y][x] = 'D';
        }
        break;
      case 'L':
        for (int i = 0; i < nb; i++) {
          x--;
          if (x < 0) {
            x = 0;
            for (int tmpy = 0; tmpy < lagoon.length; tmpy++)
              lagoon[tmpy].insert(0, ' ');
          }
          lagoon[y][x] = 'L';
        }
        break;
      case 'R':
        for (int i = 0; i < nb; i++) {
          x++;
          if (x >= lagoon[y].length) {
            for (int tmpy = 0; tmpy < lagoon.length; tmpy++)
              lagoon[tmpy].add(' ');
          }
          lagoon[y][x] = 'R';
        }
        break;
    }
    // printLagoon(lagoon);
  }

  // walk through the array to calculate the amount of cubic meters
  int result = 0;
  for (int y = 0; y < lagoon.length; y++) {
    String line = '';
    String prev = '';
    bool lava = false;
    bool prevLava = true;
    int x = 0;
    for (x = 0; x < lagoon[y].length; x++) {
      if (lagoon[y][x] != ' ') {
        result++;
        line += lagoon[y][x];
        if ((lagoon[y][x] == 'D') || (lagoon[y][x] == 'U')) {
          bool oldLava = lava;
          lava = (lagoon[y][x] != prev) ? prevLava : !prevLava;
          if (lagoon[y][x] != prev) prevLava = oldLava;
          prev = lagoon[y][x];
        }
      } else if (lava) {
        result++;
        line += '*';
      } else
        line += ' ';
    }
    if (debugMode) print(line);
  }
  if (debugMode) print(result);
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
      62);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
