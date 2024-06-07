// https://adventofcode.com/2023/day/17

import 'dart:core';
import 'dart:io';
import 'dart:collection';

const year = 2023;
const int day = 17;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

class State {
  int x = 0;
  int y = 0;
  int dx = 1;
  int dy = 0;
  int dist = 1;
  State();
  State.init(this.x, this.y, this.dx, this.dy, this.dist);

  @override
  bool operator ==(Object other) {
    return ((other is State) &&
        (x == other.x) &&
        (y == other.y) &&
        (dx == other.dx) &&
        (dy == other.dy) &&
        (dist == other.dist));
  }

  @override
  int get hashCode => Object.hash(x, y, dx, dy, dist);
  @override
  String toString() {
    return '$x,$y d=$dx,$dy $dist';
  }
}

int solution(List<String> lines) {
  // generates a grid of int costs
  List<List<int>> grid = List<List<int>>.generate(
      lines.length,
      (int index) => List<int>.generate(lines[index].length,
          (int index2) => int.parse(lines[index][index2])));
// Initialize data structures
  SplayTreeMap<int, List<State>> statesByCost =
      SplayTreeMap<int, List<State>>();
  Map<State, int> costByState = {};

  int move(int cost, int x, int y, int dx, int dy, int dist) {
    x += dx;
    y += dy;
    if ((x < 0) || (y < 0) || (x >= grid[0].length) || (y >= grid.length)) {
      return -1;
    }
    int currentCost = cost + grid[y][x];
    // arrived at destination but needs to have moved a minimum 4 blocks straight
    if ((x == grid[0].length - 1) && (y == grid.length - 1) && (dist >= 4)) {
      return (currentCost); // destination found
    }
    // updates costByState and stateByCost
    State state = State.init(x, y, dx, dy, dist);
    if (debugMode) {
      print(state);
      // print('costByState: $costByState');
      // print('stateByCost: $statesByCost');
    }
    if (!costByState.containsKey(state)) {
      if (statesByCost.containsKey(currentCost)) {
        statesByCost[currentCost]!.add(state);
      } else {
        statesByCost[currentCost] = [state];
      }
      costByState[state] = currentCost;
    }
    return 0; // not a final move
  }

  // initial moves: right and down
  move(0, 0, 0, 1, 0, 1);
  move(0, 0, 0, 0, 1, 1);
  while (true) {
    // Get lowest registered cost (a SplayTreeMap is always ordered, so firstKey)
    int currentCost = statesByCost.firstKey()!;
    // Get all states at that lowest cost and remove them from the queue
    List<State> nextStates = statesByCost[currentCost]!;
    statesByCost.remove(currentCost);
    // for each state, move +90, -90 and front (if not 3 max moves already)
    for (State state in nextStates) {
      int res;
      // minimum of 4 blocks before we can turn
      if (state.dist >= 4) {
        res = move(currentCost, state.x, state.y, state.dy, -state.dx, 1);
        if (res > 0) return res;
        res = move(currentCost, state.x, state.y, -state.dy, state.dx, 1);
        if (res > 0) return res;
      }
      // can move maximum 10 blocks straight
      if (state.dist < 10) {
        res = move(
            currentCost, state.x, state.y, state.dx, state.dy, state.dist + 1);
        if (res > 0) return res;
      }
    }
  }
}

void main() {
  assert(debugMode = true);

  assert(solution([
        '111111111111',
        '999999999991',
        '999999999991',
        '999999999991',
        '999999999991',
      ]) ==
      71);
  assert(solution([
        '2413432311323',
        '3215453535623',
        '3255245654254',
        '3446585845452',
        '4546657867536',
        '1438598798454',
        '4457876987766',
        '3637877979653',
        '4654967986887',
        '4564679986453',
        '1224686865563',
        '2546548887735',
        '4322674655533',
      ]) ==
      94);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
