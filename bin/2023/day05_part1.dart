import 'dart:core';
import 'dart:io';

const year = 2023;
const int day = 5;
const int part = 1;
final String dayStr = day.toString().padLeft(2, "0");
bool debugMode = false;

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
int convert(int seed, String mapName) {
  for (int i = 0; i < maps[mapName]!.length; i++) {
    int delta = seed - maps[mapName]![i][1];
    if ((delta >= 0) && (delta < maps[mapName]![i][2])) {
      seed = maps[mapName]![i][0] + delta;
      break;
    }
  }
  return seed;
}

int findClosestLocation(List<int> seeds) {
  // search locations of all seeds
  int? closestLocation;
  for (int seed in seeds) {
    for (String mapName in mapNames) {
      seed = convert(seed, mapName);
    }
    if (closestLocation == null)
      closestLocation = seed;
    else if (seed < closestLocation) closestLocation = seed;
  }
  return closestLocation!;
}

int solution(List<String> lines) {
  // extract the data
  int y = 0;
  // extract seeds
  for (final m in RegExp(r'\d+').allMatches(lines[y++]))
    seeds.add(int.parse(m.group(0)!));
  if (debugMode) print('seeds: $seeds');
  y++; // blank line
  // extrat maps: destination range start, source range start, range length
  for (String mapName in mapNames) {
    maps[mapName] = [];
    y++; // title line
    while ((y < lines.length) && (lines[y] != "")) {
      List<int> tmpList = [];
      for (final m in RegExp(r'\d+').allMatches(lines[y]))
        tmpList.add(int.parse(m.group(0)!));
      maps[mapName]!.add(tmpList);
      y++; // next line
    }
    y++; // blank line
  }
  if (debugMode)
    for (String mapName in mapNames) print('$mapName: ${maps[mapName]}');
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
      35);

  List<String> input =
      File('./data/$year/day${dayStr}_input.txt').readAsLinesSync();
  DateTime startTime = DateTime.now();
  print(
      "Year:$year Day:$dayStr part:$part: Solution = ${solution(input)} (in ${DateTime.now().difference(startTime).inMilliseconds}ms)");
}
