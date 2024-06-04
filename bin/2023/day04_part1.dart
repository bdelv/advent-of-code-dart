// https://adventofcode.com/2023/day/4

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 4;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

int solution(List<String> cards) {
  int result = 0;
  for (int y = 0; y < cards.length; y++) {
    // split the 2 lists in strings
    RegExpMatch? match =
        RegExp(r'Card\ +(?<id>\d+):(?<win>(\ +\d+)+) \|(?<mine>(\ +\d+)+)')
            .firstMatch(cards[y]);
    String winStr = match!.namedGroup('win')!;
    String myStr = match.namedGroup('mine')!;
    // Extract the values in lists
    List<int> winList = [];
    for (final m in RegExp(r'\d+').allMatches(winStr))
      winList.add(int.parse(m.group(0)!));
    List<int> myList = [];
    for (final m in RegExp(r'\d+').allMatches(myStr))
      myList.add(int.parse(m.group(0)!));
    // compare lists
    int tmpResult = 0;
    for (int winCard in winList)
      if (myList.contains(winCard)) {
        tmpResult = (tmpResult == 0 ? 1 : tmpResult * 2);
        if (debugMode) print('$winCard found in $myList');
      }
    result += tmpResult;
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
        'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
        'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
        'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
        'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
        'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11',
      ]) ==
      13);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
