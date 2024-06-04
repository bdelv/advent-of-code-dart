# Advent of code

Advent of Code is an Advent calendar of programming puzzles that publishes new brain teasers every day during December until the 25th.

For each day, there are 2 parts: 
- The first part can be solved usually with brute force.
- The second part, only accessible if you solved part 1, usually adds a factor of scale and is far more tricky to solve.

Links:
- [Advent Of Code](https://adventofcode.com/)
- [Dart](https://www.dartlang.org/)

Personnal goals: 
- No use of Copilot/Gemini for now. Probably for the last time ever.
- Not necessarily the most elegant solutions. The goal is just to find compute the correct result in under 10 seconds

## Preparation: Dart setup

Different ways to use Dart:
### with Dart SDK (local)

- Install Dart : https://dart.dev/get-dart

### With Nix (local)

- Install Nix:  https://nix.dev/install-nix.html
- Check that `nix-shell` is accessible from the command line
```
nix-shell
```
If launched from the root of this repository, it should download the necessary packages and enter a kind of `virtual env` that contains the needed dependencies to run the solvers (in our case, dart).

If you need to exit nix-shell, just type:
```
exit
```

### With Google Project Idx (remote, web based)

- 
- Check that `dart` is accessible from the command line
```
dart --version
```

## Preparation: Download of the input files

In order for the solvers to work, you need the input files for each day. I didn't include them in the repo as the Advent of Code developper explicitely [requested](https://adventofcode.com/2023/about#faq_copying) not to. Also there are different input files assigned to different persons (and so, different results will be accepted on the site). You need your own input files.

### input files: Find your session ID

Using Google Chrome (tested with Google Auth):
- Click on the Customize and Control button (the vertical `...`)
- Go to `More Tools`
- then `Developer Tools`
- Click the `Application tab`
- On the left side bar click `Cookies`
- On the main window you will now see the `session`
- Copy the cookie value (something like 32 hexadecimal characters)

If you want, validates the session you got (replace xxxx by the copied session id):
```
curl 'https://adventofcode.com/2023/day/1/input' -X GET -H 'Cookie: session=xxxx'
```
it should display the content of the input file of day 1 part 1 of 2023
### input files: download per year

```
dart bin/get_inputs 2023 xxxxx
```
- First parameter is the year (currently between 2015 and 2023)
- Second parameter is the session ID (should be hexadecimal)
- If the arguments are not passed or recognised, it will be asked to enter them by hand

The downloaded files are located in `./data/$year`

## launch solvers

### per day
- example: launch day 17 part 1 of year 2023
```
dart bin/2023/day17_part1.dart
```
- launch with the asserts (validates the solver on various smaller test inputs) + debug logs
```
dart --enable-asserts bin/2023/day17_part1.dart
```
### per year
There is a helper tool that will solve every day/part of a year (if the files are found in ./bin/$year)
```
dart bin/year.dart 2023
```
