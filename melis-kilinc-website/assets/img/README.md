# Görseller

Bu klasördeki dosyalar site tarafından otomatik olarak kullanılır.
Bir dosya eksik olursa site bozulmaz; yerine şık bir yer tutucu görünür.

## Mevcut dosyalar

| Dosya         | Nerede görünür                    | Ölçü        |
|---------------|-----------------------------------|-------------|
| `logo.png`    | Üst menü, "Hakkımızda" panosu     | 462×154, şeffaf zeminli |
| `favicon.png` | Tarayıcı sekmesi, telefon kısayolu| 192×192, logodaki arı |
| `melis.jpg`   | Ana bölümdeki yuvarlak portre     | 880×880 |
| `g1.jpg`      | Galeri – Kirpik lifting           | 900×1176 |
| `g2.jpg`      | Galeri – Cilt bakımı              | 900×1176 |
| `g3.jpg`      | Galeri – Protez tırnak            | 900×1176 |
| `g4.jpg`      | Galeri – Nail art                 | 900×1176 |
| `g5.jpg`      | Galeri – Kirpik lifting (2)       | 900×1176 |
| `g6.jpg`      | Galeri – Nail art (2)             | 900×1176 |

## Henüz eklenmedi

| Dosya        | Nerede görünür     | Ölçü                      |
|--------------|--------------------|---------------------------|
| `salon.jpg`  | "Hakkımızda" bölümü| 900×1125 px (4:5, dikey)  |

Salon fotoğrafı eklenene kadar o alanda logo gösteriliyor. Bu isimle bir dosya
koyduğunuzda site otomatik olarak fotoğrafı kullanmaya başlar.

## Yeni galeri görseli eklemek

1. Afişi `g7.jpg` adıyla bu klasöre koyun (en/boy oranı yaklaşık 0,765 — yani 900×1176 gibi).
2. `index.html` içindeki galeri bölümüne bir satır ekleyin:

```html
<figure class="gal reveal" data-delay="480"><img src="assets/img/g7.jpg" width="900" height="1176" alt="Uygulamanın kısa açıklaması" loading="lazy"></figure>
```

Afişler kendi başlıklarını taşıdığı için üzerlerine ayrıca yazı bindirilmiyor;
`alt` metni ise görme engelli kullanıcılar ve arama motorları için gereklidir.

## İpuçları

- Fotoğrafları web için sıkıştırın (her biri 300 KB altı) — sayfa daha hızlı açılır.
- Galeri afişlerinin oranı birbirinden farklıysa site bunları ortalayarak kırpar,
  bu yüzden önemli detayları kenarlara çok yaklaştırmayın.
