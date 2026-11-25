// Metin olarak çizilmiş bir sprite'ı keskin kenarlı SVG'ye çevirir.
// Kullanım: dart run bin/piksel_sprite.dart girdi.txt cikti.svg [olcek] [zemin]
//
// Dosya biçimi: önce "K=#140e22" gibi palet satırları, sonra "---",
// sonra her karakterin bir piksel olduğu çizim. "." boş piksel demek.

import 'dart:io';

class Sprite {
  final Map<String, String> palet;
  final List<String> satirlar;
  Sprite(this.palet, this.satirlar);

  int get genislik => satirlar.fold(0, (m, s) => s.length > m ? s.length : m);
  int get yukseklik => satirlar.length;
}

Sprite oku(String metin) {
  final palet = <String, String>{};
  final satirlar = <String>[];
  var cizim = false;
  for (final ham in metin.split('\n')) {
    final satir = ham.trimRight();
    if (!cizim) {
      if (satir == '---') {
        cizim = true;
      } else if (satir.contains('=') && !satir.startsWith('#')) {
        final parca = satir.split('=');
        palet[parca[0].trim()] = parca[1].trim();
      }
    } else if (satir.isNotEmpty) {
      satirlar.add(satir);
    }
  }
  if (satirlar.isEmpty) throw FormatException('Çizim bulunamadı ("---" satırından sonra olmalı).');
  return Sprite(palet, satirlar);
}

String svg(Sprite s, int olcek, {String? zemin}) {
  final yollar = <String, StringBuffer>{};
  for (var y = 0; y < s.yukseklik; y++) {
    final satir = s.satirlar[y];
    var x = 0;
    while (x < satir.length) {
      final c = satir[x];
      if (c == '.' || !s.palet.containsKey(c)) {
        x++;
        continue;
      }
      var son = x + 1;
      while (son < satir.length && satir[son] == c) son++;
      yollar.putIfAbsent(c, StringBuffer.new).write('M$x ${y}h${son - x}v1h${x - son}z');
      x = son;
    }
  }
  final arka = zemin == null ? '' : '<rect width="${s.genislik}" height="${s.yukseklik}" fill="$zemin"/>';
  final govde = arka + yollar.entries.map((e) => '<path fill="${s.palet[e.key]}" d="${e.value}"/>').join();
  return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${s.genislik} ${s.yukseklik}" '
      'width="${s.genislik * olcek}" height="${s.yukseklik * olcek}" shape-rendering="crispEdges">$govde</svg>';
}

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln('Kullanım: dart run bin/piksel_sprite.dart girdi.txt cikti.svg [olcek] [zemin]');
    exit(64);
  }
  final olcek = args.length > 2 ? int.parse(args[2]) : 16;
  final sprite = oku(File(args[0]).readAsStringSync());
  final zemin = args.length > 3 ? args[3] : null;
  File(args[1]).writeAsStringSync(svg(sprite, olcek, zemin: zemin));
  stdout.writeln('${args[1]}: ${sprite.genislik}x${sprite.yukseklik}, ${sprite.palet.length} renk');
}
