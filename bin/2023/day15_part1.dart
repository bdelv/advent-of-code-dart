// https://adventofcode.com/2023/day/15

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 15;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> lines) {
  int result = 0;
  // for each line (should have only one)
  for (int y = 0; y < lines.length; y++) {
    int tmpRes = 0;
    int x = 0;
    while (x <= lines[y].length) {
      if ((x == lines[y].length) || (lines[y][x] == ',')) {
        // if (debugMode) print("${lines[y]} = $tmpRes");
        result += tmpRes;
        tmpRes = 0;
      } else {
        tmpRes = ((tmpRes + lines[y].codeUnitAt(x)) * 17) % 256;
        // if (debugMode) {
        //   print("${lines[y][x]} ${lines[y].codeUnitAt(x)}");
        //   print(tmpRes);
        // }
      }
      x++;
    }
  }
  if (debugMode) print('result=$result');
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution(["HASH"]) == 52);
  assert(solution(["rn=1"]) == 30);
  assert(solution(['rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7']) ==
      1320);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
