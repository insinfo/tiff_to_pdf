import 'dart:io';
//import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWrite;
import 'package:path/path.dart' as path;

void main(List<String> arguments) async {
  print(arguments);
  var currentDir =
      arguments.isNotEmpty ? Directory(arguments.first) : Directory.current;
//final dir = Directory('path/to/directory');
  var entities = await currentDir.list(recursive: true).toList();

  print('Total de arquivos : ${entities.length}');

  for (var item in entities) {
    if (item is File) {
      var nameEx = path.basename(item.path);
      var name = path.basenameWithoutExtension(item.path);
      var fExtension = path.extension(item.path);
      //print('$fExtension ${item.path}');
      //var out = item.path.replaceAll(nameEx, name + '.pdf');
      if (fExtension.toLowerCase() == '.tif') {
        //D:\ferramentas ocr\abbyy\fine_reader_15\FineCmd.exe
        // .\FineCmd.exe C:\Users\isaque.neves\Desktop\046\0\1.TIF /lang PortugueseBrazilian /out C:\Users\isaque.neves\Desktop\046\0\1_search.pdf

        // var result = await Process.run('FineCmd.exe',
        //     [item.path, '/lang', 'PortugueseBrazilian', '/out', out]);
        // stdout.write(result.stdout);
        // stderr.write(result.stderr);

        var time = Stopwatch();
        time.start();

        await createPDF(item);
        await item.delete();

        print('Tempo total de execução : ${time.elapsed}');

        print('${DateTime.now()} arquivo: ${item.path} finalizado');
      }
    }
  }
}

Future<dynamic> createPDF(File imageFile) async {
  try {
    final image = pdfWrite.MemoryImage(imageFile.readAsBytesSync());
    final pdf = pdfWrite.Document();
    pdf.addPage(
      pdfWrite.Page(
          margin: pdfWrite.EdgeInsets.all(0),
          pageFormat: PdfPageFormat.letter,
          build: (pdfWrite.Context contex) {
            return pdfWrite.Center(child: pdfWrite.Image(image));
          }),
    );
    //final Directory? downloadsDir = await getDownloadsDirectory();
    final dir = path.dirname(imageFile.path);
    final oldFileName = path.basenameWithoutExtension(imageFile.path);
    final newPath = path.join(dir, oldFileName + '.pdf');
    final file = File(newPath);
    var bytes = await pdf.save();
    await file.writeAsBytes(bytes);
    print('createPDF $newPath');

    return null;
  } catch (e, s) {
    print('createPDF error $e $s');
    return e;
  }
}
