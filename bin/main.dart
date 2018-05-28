import 'dart:io';
import 'package:args/args.dart';
import 'package:md2codelab/md2codelab.dart' as server;

void main(List<String> args) async {
  ArgParser parser;
  ArgResults results;
  String inputPath;
  String outputPath;
  bool withjson;

  parser = _configureArgParser();
  results = parser.parse(args);

  _checkArgResults(args, parser, results);

  inputPath = results['input'].toString();
  outputPath = results['output'] == null
      ? results['input'].toString()
      : results['output'].toString();

  withjson = results['withjson'].toString() == "true";
  server.run(inputPath, outputPath, withjson);
}

void _checkArgResults(List<String> args, ArgParser parser, ArgResults results) {
  if (results['help'] == true || args.isEmpty) {
    print(parser.usage);
    return;
  }

  // Check Input as required
  if (results['input'] == null) {
    print(parser.usage);
    return;
  }

  if (FileSystemEntity.typeSync(results['input'].toString()) ==
      FileSystemEntityType.NOT_FOUND) {
    throw new FileSystemException(
        'Can not open input directory', results['input'].toString());
  }

  if (results['output'] != null &&
      FileSystemEntity.typeSync(results['output'].toString()) ==
          FileSystemEntityType.NOT_FOUND) {
    throw new FileSystemException(
        'Can not open output directory', results['output'].toString());
  }
}

ArgParser _configureArgParser() {
  var parser = new ArgParser();
  parser
    ..addOption('input',
        help: '[required] The input directory containing codelab markdown file',
        valueHelp: 'absolute path')
    ..addOption('output',
        help: 'The output directory for generated output files file',
        valueHelp: 'absolute path')
    ..addOption('withjson',
        help: 'Generated extra json files ( metadata and for research )',
        valueHelp: 'true or false',
        defaultsTo: 'false')
    ..addFlag('help', abbr: 'h', help: 'Show the usage');
  return parser;
}
