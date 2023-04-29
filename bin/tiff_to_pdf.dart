import 'dart:io';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  print(arguments);
  var currentDir =
      arguments.isNotEmpty ? Directory(arguments.first) : Directory.current;
//final dir = Directory('path/to/directory');
  var entities = await currentDir.list(recursive: true).toList();

  for (var item in entities) {
    if (item is File) {
      var nameEx = p.basename(item.path);
      var name = p.basenameWithoutExtension(item.path);
      var fExtension = p.extension(item.path);
      var out = item.path.replaceAll(nameEx, name + '.pdf');
      if (fExtension.toLowerCase() == '.tif') {
        //D:\ferramentas ocr\abbyy\fine_reader_15\FineCmd.exe
        // .\FineCmd.exe C:\Users\isaque.neves\Desktop\046\0\1.TIF /lang PortugueseBrazilian /out C:\Users\isaque.neves\Desktop\046\0\1_search.pdf

        var result = await Process.run('FineCmd.exe',
            [item.path, '/lang', 'PortugueseBrazilian', '/out', out]);
        stdout.write(result.stdout);
        stderr.write(result.stderr);
        print('${DateTime.now()} arquivo: ${item.path} finalizado');
        break;
      }
    }
  }
}
