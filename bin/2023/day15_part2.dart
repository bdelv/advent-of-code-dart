// https://adventofcode.com/2023/day/15

import 'dart:collection';
import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 15;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

const int nbBoxes = 256;

int hash(String str) {
  int res = 0;
  for (int x = 0; x < str.length; x++) {
    res = ((res + str.codeUnitAt(x)) * 17) % nbBoxes;
  }
  return res;
}

int solution(List<String> lines) {
  // initialize the maps
  List<LinkedHashMap<String, int>> boxes = [];
  for (int i = 0; i < nbBoxes; i++) {
    boxes.add(LinkedHashMap<String, int>());
  }
  // fills the maps
  for (int y = 0; y < lines.length; y++) {
    for (final match in RegExp(r'(?<label>\w+)(?<operator>[-=])(?<value>\d*)')
        .allMatches(lines[y])) {
      String label = match.namedGroup('label')!;
      int box = hash(label);
      String operator = match.namedGroup('operator')!;
      if (operator == '-') {
        if (debugMode) print('label:$label box:$box operator:$operator');
        boxes[box].remove(label);
      } else {
        int value = int.parse(match.namedGroup('value')!);
        if (debugMode) {
          print('label:$label box:$box operator:$operator value:$value');
        }
        boxes[box][label] = value;
      }
      // if (debugMode) print(boxes);
    }
  }
  // calculates the result
  int result = 0;
  for (int box = 0; box < nbBoxes; box++) {
    int slot = 0;
    boxes[box].forEach((label, value) {
      result += (box + 1) * (++slot) * value;
      // if (debugMode) print('result=$result');
    });
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution(["rn=1"]) == 1);
  assert(
      solution(['rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7']) == 145);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
