// https://adventofcode.com/2023/day/7

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 7;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

const String cardsOrder = "23456789TJQKA";

enum HandTypes { highCard, onePair, twoPair, three, fullHouse, four, five }

class CamelHand implements Comparable<CamelHand> {
  String cards = "";
  String cardsSorted = "";
  int bet = 0;
  HandTypes type = HandTypes.highCard;
  HandTypes detectType(String cards2Analyze) {
    if (RegExp(r'(\w)\1{4}').hasMatch(cards2Analyze)) return HandTypes.five;
    if (RegExp(r'(\w)\1{3}').hasMatch(cards2Analyze)) return HandTypes.four;
    if (RegExp(r'(\w)\1(\w)\2\2').hasMatch(cards2Analyze)) {
      return HandTypes.fullHouse;
    }
    if (RegExp(r'(\w)\1\1(\w)\2').hasMatch(cards2Analyze)) {
      return HandTypes.fullHouse;
    }
    if (RegExp(r'\w*(\w)\1\1\w*').hasMatch(cards2Analyze)) {
      return HandTypes.three;
    }
    if (RegExp(r'\w?(\w)\1\w?(\w)\2\w?').hasMatch(cards2Analyze)) {
      return HandTypes.twoPair;
    }
    if (RegExp(r'\w*(\w)\1\w*').hasMatch(cards2Analyze)) {
      return HandTypes.onePair;
    }
    return HandTypes.highCard;
  }

  CamelHand(this.cards, this.bet) {
    // sort hands by face value
    List<String> char = cards.split('');
    char.sort((a, b) => cardsOrder.indexOf(b) - cardsOrder.indexOf(a));
    cardsSorted = char.join();
    // detect type
    type = detectType(cardsSorted);
  }

  // override compareTo for list.sort(): first by type, then alphabetically
  @override
  int compareTo(CamelHand other) {
    if (type != other.type) return type.index.compareTo(other.type.index);
    for (int i = 0; i < cards.length; i++) {
      int delta =
          cardsOrder.indexOf(cards[i]) - cardsOrder.indexOf(other.cards[i]);
      if (delta != 0) return delta;
    }
    return 0;
  }

  @override
  String toString() {
    return "cards:$cards sorted:$cardsSorted bet:$bet type:$type\n";
  }
}

int solution(List<String> lines) {
  List<CamelHand> hands = [];
  int result = 0;

  // extract the data
  for (int y = 0; y < lines.length; y++) {
    RegExpMatch? match =
        RegExp(r'(?<hand>\S+) (?<bet>\d+)').firstMatch(lines[y]);
    hands.add(CamelHand(
        match!.namedGroup('hand')!, int.parse(match.namedGroup('bet')!)));
  }
  hands.sort();
  if (debugMode) print(hands);
  for (int rank = 1; rank <= hands.length; rank++) {
    result += rank * hands[rank - 1].bet;
  }
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '32T3K 765',
        'T55J5 684',
        'KK677 28',
        'KTJJT 220',
        'QQQJA 483',
      ]) ==
      6440);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
