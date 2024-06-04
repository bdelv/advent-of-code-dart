import 'dart:core';
import 'dart:io';
import 'dart:collection';

const year = 2023;
const int day = 16;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  HashMap<int, int> cache = HashMap<int, int>();
  List<List<bool>> energized = [];
  for (int y = 0; y < lines.length; y++) {
    energized.add([]);
    for (int x = 0; x < lines[y].length; x++) energized[y].add(false);
  }

  void beam(int x, int y, int dirx, int diry) {
    while (true) {
      x += dirx;
      y += diry;
      if ((y < 0) || (y >= lines.length) || (x < 0) || (x >= lines[y].length))
        break;
      int hash = x * 100000 + y * 100 + dirx * 10 + diry;
      if (cache.containsKey(hash)) break;
      cache[hash] = 0;
      energized[y][x] = true;
      if (debugMode) print("$x,$y $dirx,$diry");
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

  beam(-1, 0, 1, 0);
  int result = 0;
  for (int y = 0; y < lines.length; y++)
    for (int x = 0; x < lines[y].length; x++) if (energized[y][x]) result++;
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
      46);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
