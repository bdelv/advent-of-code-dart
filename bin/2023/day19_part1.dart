// https://adventofcode.com/2023/day/19

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 19;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class Rule {
  String category = '';
  String operator = '';
  int value = 0;
  String destination = '';
  Rule(this.category, this.operator, this.value, this.destination);
  Rule.destination(this.destination);
  @override
  String toString() {
    return '$category$operator$value -> $destination';
  }
}

int solution(List<String> lines) {
  Map<String, List<Rule>> workflows = {};
  List<String> catName = ['x', 'm', 'a', 's'];
  // imports the workflows
  int y = 0;
  while (lines[y] != '') {
    RegExpMatch? match =
        RegExp(r'^(?<workflow>\w+){(?<rules>([\w\d<>:]+,?)+)}$')
            .firstMatch(lines[y]);
    String workflow = match!.namedGroup('workflow')!;
    String strRules = match.namedGroup('rules')!;

    List<Rule> rules = [];
    for (final m
        in RegExp(r'(?<part>\w+)(?<ope>[\<\>]?)(?<value>\d*):?(?<dest>\w*)')
            .allMatches(strRules)) {
      String? tmpPart = m.namedGroup('part');
      String? tmpOpe = m.namedGroup('ope');
      String? tmpVal = m.namedGroup('value');
      String? tmpDest = m.namedGroup('dest');
      if (tmpOpe! == '') {
        rules.add(Rule.destination(tmpPart!));
      } else {
        rules.add(Rule(tmpPart!, tmpOpe, int.parse(tmpVal!), tmpDest!));
      }
    }
    if (debugMode) print(rules);
    workflows[workflow] = rules;
    y++;
  }
  // imports the parts and check if accepted or refused
  int result = 0;
  for (int i = y + 1; i < lines.length; i++) {
    RegExpMatch? match =
        RegExp(r'^{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}$')
            .firstMatch(lines[i]);
    Map<String, int> values = {};
    for (String cat in catName) {
      values[cat] = int.parse(match!.namedGroup(cat)!);
    }
    String currWorkflow = 'in';
    while ((currWorkflow != 'A') && (currWorkflow != 'R')) {
      for (Rule rule in workflows[currWorkflow]!) {
        if ((rule.operator == '') ||
            ((rule.operator == '<') && (values[rule.category]! < rule.value)) ||
            ((rule.operator == '>') && (values[rule.category]! > rule.value))) {
          currWorkflow = rule.destination;
          break;
        }
      }
    }
    if (currWorkflow == 'A') {
      for (String cat in catName) {
        result += values[cat]!;
      }
    }
  }
  if (debugMode) print(result);
  return result;
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'px{a<2006:qkq,m>2090:A,rfg}',
        'pv{a>1716:R,A}',
        'lnx{m>1548:A,A}',
        'rfg{s<537:gd,x>2440:R,A}',
        'qs{s>3448:A,lnx}',
        'qkq{x<1416:A,crn}',
        'crn{x>2662:A,R}',
        'in{s<1351:px,qqz}',
        'qqz{s>2770:qs,m<1801:hdj,R}',
        'gd{a>3333:R,R}',
        'hdj{m>838:A,pv}',
        '',
        '{x=787,m=2655,a=1222,s=2876}',
        '{x=1679,m=44,a=2067,s=496}',
        '{x=2036,m=264,a=79,s=2244}',
        '{x=2461,m=1339,a=466,s=291}',
        '{x=2127,m=1623,a=2188,s=1013}',
      ]) ==
      19114);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
