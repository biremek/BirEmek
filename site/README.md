# QWET — askıda küvet tanıtım sitesi

TPU kaplı polyester kumaştan üretilen askıda küvet için tek sayfalık, animasyonlu
tanıtım ve ön sipariş sitesi. Derleme adımı yok: saf HTML + CSS + JavaScript.

```
site/
├── index.html      tüm içerik ve bölümler
├── styles.css      tasarım sistemi, animasyonlar, responsive
├── script.js       etkileşimler (renk seçici, form, kaydırma efektleri)
└── assets/         ürün görselleri + favicon
```

## Çalıştırma

```bash
cd site
python3 -m http.server 8080
# http://127.0.0.1:8080
```

Dosyaları doğrudan çift tıklayarak da açabilirsiniz; yalnızca `localStorage`
kullanan ön sipariş kaydı `file://` üzerinde bazı tarayıcılarda engellenir.

## Yayınlama

`site/` klasörünün içeriğini herhangi bir statik barındırmaya atmak yeterli
(Netlify, Vercel, GitHub Pages, cPanel). Sunucu tarafı gereksinimi yoktur.

## Ön sipariş formunu gerçek sisteme bağlama

Form şu an doğrulamayı yapıp kaydı tarayıcıdaki `localStorage`'a yazıyor
(`qwet.orders` anahtarı). Kayıtları görmek için tarayıcı konsolunda:

```js
JSON.parse(localStorage.getItem('qwet.orders'))
```

Canlıya alırken `script.js` içindeki **9. bölümde**, `// Burası gerçek uçla
değiştirilecek` yorumunun bulunduğu `setTimeout` bloğunu kendi uç noktanızla
değiştirin:

```js
fetch('https://api.biremek.com/on-siparis', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(order)
})
  .then((r) => { if (!r.ok) throw new Error('sunucu'); return r.json(); })
  .then(() => { /* başarı ekranını göster */ })
  .catch(() => { /* kullanıcıya hata mesajı göster */ });
```

`order` nesnesi şu alanları taşır: `kod, ad, eposta, telefon, renk, sehir,
kurulum, adet, not, tutar, tarih`.

Sunucu istemiyorsanız Formspree, Basin veya Google Forms gibi bir servisin
POST adresi de doğrudan kullanılabilir.

## Fiyat ve kontenjan

- Birim fiyat `script.js` içinde `const UNIT = 13900;` satırında.
- Liste fiyatı ve indirim rozeti `index.html` içinde `.order__price` bloğunda.
- Dolan kontenjan `index.html` içinde `<b id="stockCount">312</b>` değerinde;
  ilerleme çubuğu bu sayıdan otomatik hesaplanır.

## Renkler

Beş kumaş rengi `index.html` içindeki `.sw` butonlarında `data-*` öznitelikleriyle
tanımlı (`data-key, data-name, data-code, data-hex, data-desc`). Bir rengi
değiştirmek için hem bu satırı hem de `assets/room-<key>.jpg` ile
`assets/swatch-<key>.jpg` görsellerini güncelleyin; form açılır listesindeki
karşılık gelen `<option>` metni de aynı olmalıdır.

Seçilen renk sayfanın vurgu rengini de değiştirir. Koyu tonlar (Midnight Navy)
siyah zeminde okunamadığı için `script.js` içindeki `readable()` fonksiyonu
vurgu rengini tonunu koruyarak açar — beş rengin tamamında metin kontrastı
7:1'in üzerindedir. Kumaşın gerçek rengi renk diskinde ve fotoğrafta olduğu
gibi kalır.

## Görseller

`assets/` içindeki fotoğraflar, tasarım referansı olarak verilen görsellerden
kırpılmıştır. Kumaş etiketlerinde ve ambalaj fotoğrafında **referans markanın
adı okunuyor**; siteyi yayına almadan önce bunları kendi ürün çekimlerinizle
değiştirin. Dosya adlarını korursanız başka bir değişiklik gerekmez.

## Erişilebilirlik ve performans

- `prefers-reduced-motion` açıksa tüm animasyonlar kapanır.
- Mobil menü klavye ile kullanılabilir, `Esc` ile kapanır.
- Görseller `loading="lazy"` ile, hero görseli `fetchpriority="high"` ile yüklenir.
- Yazı tipleri Google Fonts'tan gelir; erişilemezse sistem serif/sans yedeğine düşer.
