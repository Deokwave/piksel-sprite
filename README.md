# piksel-sprite

Avatarları ve küçük ikonları önce düz metin olarak çiziyoruz: her karakter bir piksel, başta da hangi karakterin hangi renk olduğunu yazan bir palet. Bu Dart aracı o dosyayı keskin kenarlı bir SVG'ye çeviriyor.

```
dart run bin/piksel_sprite.dart ornek/dalga.txt dalga.svg 16
```

Dördüncü değer olarak bir renk verirsen sprite'ın arkası o renkle doluyor: `dart run bin/piksel_sprite.dart ornek/kalp.txt kalp.svg 16 "#070b22"`.

`ornek` klasöründe iki örnek var: Deokwave dalgası (`dalga.txt`) ve bir kalp (`kalp.txt`). Palet satırlarının ve çizimin nasıl yazıldığını görmek için onlara bakabilirsin.

© 2026 Deokwave. Tüm hakları saklıdır.
