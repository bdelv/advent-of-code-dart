// https://adventofcode.com/2023/day/8

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 8;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Node {
  String right;
  String left;
  Node(this.left, this.right);
}

int solution(List<String> lines) {
  String path = lines[0];
  Map<String, Node> nodes = {};

  // extract the data
  for (int y = 2; y < lines.length; y++) {
    RegExpMatch? match =
        RegExp(r'(?<name>\S{3}) = \((?<left>\S{3}), (?<right>\S{3})\)')
            .firstMatch(lines[y]);
    nodes[match!.namedGroup('name')!] =
        Node(match.namedGroup('left')!, match.namedGroup('right')!);
  }
  // search for ZZZ
  if (debugMode) print('----------');
  String pos = 'AAA';
  int count = 0;
  while (pos != 'ZZZ') {
    String dir = path[count % path.length];
    if (debugMode) print('$pos $dir');
    if (dir == 'R') {
      pos = nodes[pos]!.right;
    } else {
      pos = nodes[pos]!.left;
    }
    count++;
  }
  return count;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'RL',
        '',
        'AAA = (BBB, CCC)',
        'BBB = (DDD, EEE)',
        'CCC = (ZZZ, GGG)',
        'DDD = (DDD, DDD)',
        'EEE = (EEE, EEE)',
        'GGG = (GGG, GGG)',
        'ZZZ = (ZZZ, ZZZ)',
      ]) ==
      2);
  assert(solution([
        'LLR',
        '',
        'AAA = (BBB, BBB)',
        'BBB = (AAA, ZZZ)',
        'ZZZ = (ZZZ, ZZZ)',
      ]) ==
      6);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
