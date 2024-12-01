// downloads the input files of AdventOfCode using your personal session id (input files are different for different persons)
// usage: dart bin/get_inputs.dart 2023 xxxxxx
// parameters:
// - year: Currently available years: 2015..2023
// - SessionID: log in to the advent of code site, go in developper tools->Application tab->Cookies and copy the cookie value
import 'dart:io';
import 'dart:convert';

const int minYear = 2015;
const int maxYear = 2024;

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

// gets the sessions id (should be hexadecimal) from arguments, or input
  String? sessionId;
  if (arguments.length > 1) sessionId = arguments[1];
  while ((sessionId == null) ||
      ((sessionId.length >= 16) &&
          (RegExp(r'^[0-9a-fA-F]+$').matchAsPrefix(sessionId) == null))) {
    print('Please enter the session:');
    sessionId = stdin.readLineSync();
  }

// Creates the folder that will contain the input files if it doesn't exist
  String localPath = './data/$year';
  if (!await Directory(localPath).exists()) {
    Directory(localPath).createSync(recursive: true);
  }

// downloads the input files for the 25 days of the selected year
  for (int day = 1; day <= 25; day++) {
    String file2Dl = "https://adventofcode.com/$year/day/$day/input";
    String fileDest =
        '$localPath/day${day.toString().padLeft(2, '0')}_input.txt';
    print('Downloading $file2Dl to $fileDest...');
    HttpClient client = HttpClient();
    try {
      HttpClientRequest clientRequest = await client.getUrl(Uri.parse(file2Dl));
      clientRequest.cookies.add(Cookie("session", sessionId));
      HttpClientResponse clientResponse = await clientRequest.close();
      if (clientResponse.statusCode != 200) {
        throw Exception(
            'Error! Status code: ${clientResponse.statusCode}. Are you sure of your session ID?');
      } else {
        clientResponse.transform(Utf8Decoder()).toList().then((data) {
          var body = data.join('');
          var file = File(fileDest);
          file.writeAsStringSync(body);
          client.close();
        });
      }
    } on Exception catch (e) {
      print('$e');
      exit(-1);
    }
  }
}
