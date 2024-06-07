// https://adventofcode.com/2023/day/5

import 'dart:core';
import 'dart:io';
import 'dart:math';

const year = 2023;
const int day = 5;
const int part = 2;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

const maxInt = 0x7fffffffffffffff; // a bit dirty. Dart has no MAXINT
List<int> seeds = [];
Map<String, List<List<int>>> maps = {};
List<String> mapNames = [
  "seedToSoil",
  "soilToFertilizer",
  "fertilizerToWater",
  "waterToLight",
  "lightToTemperature",
  "temperatureToHumidity",
  "humidityToLocation"
];

// uses a convertion map
int convert(int seed, int range, int mapIdx) {
  // print('seed:$seed range:$range mapIdx:$mapIdx');
  if (mapIdx >= mapNames.length) return seed;
  if (range <= 0) return maxInt;

  String mapName = mapNames[mapIdx];

  // convert into a list of ranges
  for (int i = 0; i < maps[mapName]!.length; i++) {
    // check if the interval contains the seed
    int intervalDest = maps[mapName]![i][0];
    int intervalSrc = maps[mapName]![i][1];
    int intervalRange = maps[mapName]![i][2];

    int delta = seed - intervalSrc;
    if ((delta >= 0) && (delta < intervalRange)) {
      int takenRange = min(range, intervalRange - delta);
      return min(convert(intervalDest + delta, takenRange, mapIdx + 1),
          convert(seed + takenRange, range - takenRange, mapIdx));
    } else {
      // check if the given range contains in part the mapping interval
      int delta = intervalSrc - seed;
      int takenRange = min(range - delta, intervalRange);
      if ((delta >= 0) && (delta < range)) {
        return min(
            min(convert(seed, delta, mapIdx),
                convert(intervalDest, takenRange, mapIdx + 1)),
            convert(
                intervalSrc + takenRange, range - delta - takenRange, mapIdx));
      }
    }
  }
  return convert(seed, range, mapIdx + 1);
}

int findClosestLocation(List<int> seeds) {
  int closestLocation = maxInt;
  int idxSeed = 0;
  // pass through all seeds
  while (idxSeed < seeds.length) {
    closestLocation =
        min(convert(seeds[idxSeed], seeds[idxSeed + 1], 0), closestLocation);
    idxSeed += 2;
  }
  return closestLocation;
}

int solution(List<String> lines) {
  // extract the data
  int y = 0;
  // extract seeds
  for (final m in RegExp(r'\d+').allMatches(lines[y++])) {
    seeds.add(int.parse(m.group(0)!));
  }
  if (debugMode) print('seeds: $seeds');
  y++; // blank line
  // extrat maps: destination range start, source range start, range length
  for (String mapName in mapNames) {
    maps[mapName] = [];
    y++; // title line
    while ((y < lines.length) && (lines[y] != "")) {
      List<int> tmpList = [];
      for (final m in RegExp(r'\d+').allMatches(lines[y])) {
        tmpList.add(int.parse(m.group(0)!));
      }
      maps[mapName]!.add(tmpList);
      y++; // next line
    }
    y++; // blank line
  }
  if (debugMode)
    for (String mapName in mapNames) {
      print('$mapName: ${maps[mapName]}');
    }
  return findClosestLocation(seeds);
}

void main() {
  assert(debugMode = true);

  assert(solution([
        'seeds: 79 14 55 13',
        '',
        'seed-to-soil map:',
        '50 98 2',
        '52 50 48',
        '',
        'soil-to-fertilizer map:',
        '0 15 37',
        '37 52 2',
        '39 0 15',
        '',
        'fertilizer-to-water map:',
        '49 53 8',
        '0 11 42',
        '42 0 7',
        '57 7 4',
        '',
        'water-to-light map:',
        '88 18 7',
        '18 25 70',
        '',
        'light-to-temperature map:',
        '45 77 23',
        '81 45 19',
        '68 64 13',
        '',
        'temperature-to-humidity map:',
        '0 69 1',
        '1 0 69',
        '',
        'humidity-to-location map:',
        '60 56 37',
        '56 93 4',
      ]) ==
      46);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
