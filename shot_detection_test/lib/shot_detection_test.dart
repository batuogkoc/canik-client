import 'package:csv/csv.dart';
import "dart:io";
import 'dart:convert';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.write("No file specified\n");
    return;
  }
  String path = args[0];
  CsvToProccessedData(path);
}

void CsvToProccessedData(String path) {
  if (!FileSystemEntity.isFileSync(path)) {
    stderr.write("No file at $path \n");
    return;
  }
  File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .forEach((element) {
    stdout.writeln(element);
  });
}
