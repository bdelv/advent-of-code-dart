// https://adventofcode.com/2023/day/8

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 8;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Node {
  String right;
  String left;
  String name;
  Node(this.name, this.left, this.right);
}

// LCM of two numbers
int lcm(int a, int b) {
  if ((a == 0) || (b == 0)) return 0;
  return ((a ~/ a.gcd(b)) * b).abs();
}

// LCM of multiple numbers
int lcmMany(List<int> integers) {
  if (integers.isEmpty) return 1;
  var tmpLcm = integers[0].abs();
  for (var i = 1; i < integers.length; i++) tmpLcm = lcm(tmpLcm, integers[i]);
  return tmpLcm;
}

int solution(List<String> lines) {
  String path = lines[0];
  // extract the data
  Map<String, Node> nodes = {};
  for (int y = 2; y < lines.length; y++) {
    RegExpMatch? match =
        RegExp(r'(?<name>\S{3}) = \((?<left>\S{3}), (?<right>\S{3})\)')
            .firstMatch(lines[y]);
    nodes[match!.namedGroup('name')!] = Node(match.namedGroup('name')!,
        match.namedGroup('left')!, match.namedGroup('right')!);
  }
  // search all nodes ending by A
  List<String> currentNodes = [];
  List<List<int>> loops = [];
  nodes.forEach((key, value) {
    if (key[key.length - 1] == 'A') {
      currentNodes.add(key);
      loops.add([0]);
    }
  });
  // print(currentNodes);
  // advance the nodes until all finish with Z
  int count = 0;
  bool allEndWithZ = false;
  while (!allEndWithZ) {
    allEndWithZ = true;
    for (int i = 0; i < currentNodes.length; i++) {
      if (path[count % path.length] == 'R')
        currentNodes[i] = nodes[currentNodes[i]]!.right;
      else
        currentNodes[i] = nodes[currentNodes[i]]!.left;
      if (currentNodes[i][currentNodes[i].length - 1] != 'Z')
        allEndWithZ = false;
      else {
        if (debugMode) print('i:$i count:${count + 1}');
        loops[i].add(count);
      }
      // Checks if all nodes are looping
      bool allLoopsFound = true;
      for (int i2 = 0; i2 < loops.length; i2++)
        if (!((loops[i2].length > 2) &&
            (loops[i2][loops[i2].length - 1] -
                    loops[i2][loops[i2].length - 2] ==
                loops[i2][loops[i2].length - 2] -
                    loops[i2][loops[i2].length - 3]))) allLoopsFound = false;
      if (allLoopsFound) {
        if (debugMode) {
          print('All nodes have loops!');
          print(loops);
        }
        return lcmMany(List<int>.generate(
            loops.length,
            (int index) =>
                loops[index][loops[index].length - 1] -
                loops[index][loops[index].length - 2]));
      }
    }
    // if (debugMode) print(currentNodes);
    count++;
  }
  return count;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'LR',
        '',
        '11A = (11B, XXX)',
        '11B = (XXX, 11Z)',
        '11Z = (11B, XXX)',
        '22A = (22B, XXX)',
        '22B = (22C, 22C)',
        '22C = (22Z, 22Z)',
        '22Z = (22B, 22B)',
        'XXX = (XXX, XXX)',
      ]) ==
      6);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
