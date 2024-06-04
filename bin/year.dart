import 'dart:io';

const int minYear = 2015;
const int maxYear = 2023;

void main(List<String> arguments) async {
  // gets the year from arguments, or input
  int? year;
  String? yearStr;
  if (arguments.isNotEmpty) {
    yearStr = arguments[0];
    year = int.tryParse(yearStr);
  }
  while ((year == null) || (year.clamp(minYear, maxYear) != year)) {
    print('Please enter the year (must be between $minYear and $maxYear):');
    yearStr = stdin.readLineSync()!;
    year = int.tryParse(yearStr);
  }

  // execute a shell 'dart run' on each day[1-25] and each part[1-2] until an error is encountered
  for (int day = 1; day <= 25; day++) {
    for (int part = 1; part <= 2; part++) {
      String file =
          './bin/$year/day${day.toString().padLeft(2, '0')}_part$part.dart';
      if (File(file).existsSync()) {
        ProcessResult results = await Process.run('dart', [file],
            runInShell: true, workingDirectory: '.');
        if (results.exitCode != 0) {
          print(results.stderr);
          exit(-1);
        } else
          print(results.stdout);
      }
    }
  }
}
