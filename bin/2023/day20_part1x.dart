// https://adventofcode.com/2023/day/20

import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 20;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

enum TypeModule { untyped, /*button,*/ broadcast, flipflop, conjunction }

Map<bool, int> countPulses = {false: 0, true: 0};

class Module {
  String name = '';
  TypeModule type = TypeModule.untyped;
  bool state = false;
  List<String> destModules = [];
  List<bool> inputs = [];
  Module(this.name, this.destModules) {
    if (name[0] == '%') {
      type = TypeModule.flipflop;
      name = name.substring(1);
    } else if (name[0] == '&') {
      type = TypeModule.conjunction;
      name = name.substring(1);
    } // else if (name == 'button')
    // type = TypeModule.button;
    else if (name == 'broadcaster') {
      type = TypeModule.broadcast;
    } else {
      type = TypeModule.untyped;
    }
  }
  void pulse(bool state) {
    if (type != TypeModule.untyped) inputs.add(state);
    countPulses[state] = countPulses[state]! + 1;
  }

  @override
  String toString() {
    return '$name, $type, $state, $destModules, $inputs';
  }
}

int solution(List<String> lines, int nbPress) {
  Map<String, Module> modules = {};
  // adds an initial button -> broadcaster (push=>trigger low)
  // modules['button'] = Module('button', ['broadcaster']);
  for (String line in lines) {
    RegExpMatch? match =
        RegExp(r'^(?<name>[%&]?\w+) -> (?<dest>[ ,\w]+)$').firstMatch(line);
    String name = match!.namedGroup('name')!;
    String dest = match.namedGroup('dest')!;
    Module mod = Module(name, dest.split(', '));
    modules[mod.name] = mod;
  }
  print(modules);
  countPulses = {false: 0, true: 0};
  for (int press = 1; press <= nbPress; press++) {
    // initial pulse
    modules['broadcaster']!.pulse(false);
    bool signalsRemaining;
    do {
      signalsRemaining = false;
      for (Module mod in modules.values) {
        if (mod.inputs.isNotEmpty) {
          switch (mod.type) {
            // press button => a single low puls is sent to broadcaster
            // broadcaster -> [xxx]
            // case TypeModule.button:
            case TypeModule.broadcast:
              for (String dest in mod.destModules) {
                modules[dest]!.pulse(mod.inputs[0]);
              }
              mod.inputs.removeAt(0);
              break;
            // %flipflop -> [xxx] (high=ignored. low=>flip)
            case TypeModule.flipflop:
              if (!mod.inputs[0]) {
                mod.state = !mod.state;
                for (String dest in mod.destModules) {
                  modules[dest]!.pulse(mod.state);
                }
              }
              mod.inputs.removeAt(0);
              break;
            // &conjunction -> [xxx] (all high=>low, or send high)
            case TypeModule.conjunction:
              bool pulse = mod.inputs.contains(false);
              for (String dest in mod.destModules) {
                if (modules[dest] == null) {
                  countPulses[pulse] = countPulses[pulse]! + 1;
                } else {
                  modules[dest]!.pulse(pulse);
                }
              }
              mod.inputs.clear();
              break;
            case TypeModule.untyped:
              break;
          }
          if (mod.inputs.isNotEmpty) signalsRemaining = true;
        }
      }
    } while (signalsRemaining);
  }
  int result = countPulses[true]! * countPulses[false]!;
  print('${countPulses[false]} * ${countPulses[true]} = $result');
  return result;
}

void main() {
  assert(debugMode = true);

  // assert(solution([
  //       'broadcaster -> a, b, c',
  //       '%a -> b',
  //       '%b -> c',
  //       '%c -> inv',
  //       '&inv -> a',
  //     ], 1) ==
  //     32);
  // assert(solution([
  //       'broadcaster -> a, b, c',
  //       '%a -> b',
  //       '%b -> c',
  //       '%c -> inv',
  //       '&inv -> a',
  //     ], 1000) ==
  //     32000000);
  assert(solution([
        'broadcaster -> a',
        '%a -> inv, con',
        '&inv -> b',
        '%b -> con',
        '&con -> output',
      ], 1000) ==
      11687500);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Day $dayStr part $part: Solution = ${solution(input, 1000)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
