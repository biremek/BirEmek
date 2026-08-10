# Melis Kılınç Güzellik Salonu & Beslenme Kliniği — Web Sitesi

Diyetisyen Melis Kılınç Güzellik Salonu & Beslenme Kliniği (Pozcu / Mersin) için hazırlanmış,
tek sayfalık, animasyonlu ve tamamen duyarlı (mobil + masaüstü) tanıtım sitesi.

## Özellikler

- **Tek sayfa, hızlı açılış** — çerçeve veya derleme adımı yok, sadece HTML/CSS/JS.
- **Kaydırma animasyonları** — `IntersectionObserver` ile bölümler görünür alana girdikçe
  yumuşak geçişlerle beliriyor (soldan, sağdan, aşağıdan, ölçekli).
- **Parallax ve hareketli arka planlar** — ana bölümde yüzen renkli ışık lekeleri.
- **Animasyonlu sayaçlar** — takipçi sayısı, kampanya fiyatı gibi rakamlar sayarak artıyor.
- **Sabit üst menü** — kaydırınca küçülüp bulanık cam görünümüne geçiyor, aktif bölümü
  otomatik olarak vurguluyor.
- **Mobil menü** — sağdan açılan tam ekran çekmece menü.
- **Sabit WhatsApp butonu** ve yukarı çıkma butonu.
- **Google Haritalar** üzerinden konum ve "Yol Tarifi Al" bağlantısı.
- **SEO** — Türkçe meta etiketleri, Open Graph ve `HealthAndBeautyBusiness` yapılandırılmış
  verisi (Google işletme sonuçları için).
- **Erişilebilirlik** — klavye odak halkaları, ARIA etiketleri ve
  `prefers-reduced-motion` desteği (animasyon hassasiyeti olan kullanıcılar için).

## Bölümler

1. **Ana Sayfa (Hero)** — isim, slogan, randevu butonları, öne çıkan rakamlar
2. **Hakkımızda** — salon tanıtımı ve öne çıkan farklar
3. **Hizmetler** — Instagram profilindeki hizmetlerin tamamı (9 kart)
4. **Beslenme Kliniği** — diyetisyen süreci (4 adım) ve danışmanlık türleri
5. **Kampanya** — "Üç Bölge 10 Seans" lazer epilasyon kampanyası
6. **Galeri** — çalışmalardan kareler + Instagram bağlantısı
7. **İletişim** — telefonlar, WhatsApp, Instagram, adres, çalışma saatleri, harita

## Dosya yapısı

```
melis-kilinc-website/
├── index.html              # Tüm sayfa içeriği
├── assets/
│   ├── css/style.css       # Tasarım ve animasyonlar
│   ├── js/main.js          # Etkileşimler (bağımlılık yok)
│   └── img/                # Fotoğraflar (README.md içinde liste var)
└── README.md
```

## Yayına alma

Derleme gerektirmez. Klasörün içeriğini herhangi bir sunucuya veya ücretsiz statik
barındırma servisine yüklemeniz yeterlidir:

- **GitHub Pages** — depo ayarlarından Pages'i açıp bu klasörü kaynak olarak seçin.
- **Netlify / Vercel / Cloudflare Pages** — klasörü sürükleyip bırakın.
- **Klasik hosting (cPanel)** — dosyaları `public_html` içine kopyalayın.

Yerelde denemek için:

```bash
cd melis-kilinc-website
python3 -m http.server 8000
# tarayıcıda: http://localhost:8000
```

## Kolayca düzenlenebilecek yerler

| Ne değişecek        | Nerede                                                        |
|---------------------|---------------------------------------------------------------|
| Telefon numaraları  | `index.html` içinde `tel:` ve `wa.me/` bağlantıları           |
| Adres / harita      | `index.html` → `#iletisim` bölümündeki `iframe` ve adres kartı |
| Çalışma saatleri    | `index.html` → "Çalışma Saatleri" kartı ve alt bilgi           |
| Hizmetler           | `index.html` → `<article class="service">` blokları            |
| Kampanya fiyatı     | `index.html` → `data-count="6000"`                             |
| Renkler             | `assets/css/style.css` → en üstteki `:root` değişkenleri       |
| Fotoğraflar         | `assets/img/` (adlandırma için oradaki README'ye bakın)        |

## Notlar

- Sitedeki hizmetler, telefon numaraları ve kampanya bilgisi
  [@meliskilincguzellik](https://www.instagram.com/meliskilincguzellik) Instagram profilinden alınmıştır.
- Adres olarak profilde belirtilen **Pozcu / Mersin** kullanılmıştır. Açık adres (sokak, bina no)
  netleştiğinde `#iletisim` bölümündeki adres kartını ve harita bağlantısını güncellemek yeterlidir.
- Fotoğraflar eklenmeden de site eksiksiz görünür; görsel alanlar zarif yer tutucularla doldurulur.
