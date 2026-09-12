/* =========================================================
   QWET — askıda küvet · etkileşim katmanı
   ========================================================= */
(function () {
  'use strict';

  const $  = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------------------------------------------------------
     1. AÇILIŞ PERDESİ
     --------------------------------------------------------- */
  const loader = $('#loader');
  const loaderWord = $('#loaderWord');
  const navName = $('#navName');
  const MIN_LOAD = reduced ? 0 : 1400;
  const FLIGHT = 1000;
  const t0 = performance.now();
  let closed = false;

  function settleNav() {
    $('#nav').classList.add('is-named');
    loader.classList.add('is-done');
    // geçişi önce kapat, yoksa transform sıfırlanırken ortaya geri uçar
    loaderWord.style.transition = 'none';
    loaderWord.style.transform = '';
    document.body.classList.remove('is-locked');
  }

  // Perdedeki büyük QWET yazısı, ölçülen konum farkına göre
  // nav'daki logonun tam üstüne uçar (FLIP). Ölçüm gerçek
  // kutulardan alındığı için ekran boyutundan bağımsız oturur.
  function flyLogoToNav() {
    const nav = $('#nav');
    const showNav = () => nav.classList.replace('is-loading', 'is-ready');

    if (reduced) { showNav(); settleNav(); revealInView(); return; }

    // nav opacity 0 olsa da yerleşimi hazır; ölçüm buradan alınır
    const from = loaderWord.getBoundingClientRect();
    const to = navName.getBoundingClientRect();
    if (!from.width || !to.width) { showNav(); settleNav(); revealInView(); return; }

    const scale = to.width / from.width;
    const dx = to.left - from.left;
    const dy = (to.top + to.height / 2) - (from.top + from.height / 2);

    loader.classList.add('is-exiting');
    revealInView();

    requestAnimationFrame(() => {
      loaderWord.style.transformOrigin = 'left center';
      loaderWord.style.transition = `transform ${FLIGHT}ms cubic-bezier(.76,0,.24,1)`;
      loaderWord.style.transform = `translate(${dx}px, ${dy}px) scale(${scale})`;
    });

    setTimeout(showNav, FLIGHT * 0.45);
    setTimeout(settleNav, FLIGHT);
  }

  function closeLoader() {
    if (closed) return;
    closed = true;
    setTimeout(flyLogoToNav, Math.max(0, MIN_LOAD - (performance.now() - t0)));
  }
  document.body.classList.add('is-locked');
  window.addEventListener('load', closeLoader);
  setTimeout(closeLoader, 4000); // güvenlik ağı

  /* ---------------------------------------------------------
     2. GİRİŞ ANİMASYONLARI (IntersectionObserver)
     --------------------------------------------------------- */
  const revealTargets = $$('[data-reveal]');

  const revealObs = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (e.isIntersecting) {
        e.target.classList.add('is-in');
        revealObs.unobserve(e.target);
      }
    });
  }, { rootMargin: '0px 0px -12% 0px', threshold: 0.08 });

  revealTargets.forEach((el) => revealObs.observe(el));

  // perde kapanınca ekranda görünenleri hemen aç
  function revealInView() {
    revealTargets.forEach((el) => {
      const r = el.getBoundingClientRect();
      if (r.top < window.innerHeight * 0.92) el.classList.add('is-in');
    });
  }

  /* ---------------------------------------------------------
     3. SAYAÇLAR
     --------------------------------------------------------- */
  const counters = $$('[data-count]');
  const countObs = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (!e.isIntersecting) return;
      countObs.unobserve(e.target);
      const end = parseInt(e.target.dataset.count, 10);
      if (reduced) { e.target.textContent = end; return; }
      const dur = 1400;
      const start = performance.now();
      (function tick(now) {
        const p = Math.min(1, (now - start) / dur);
        const eased = 1 - Math.pow(1 - p, 3);
        e.target.textContent = Math.round(end * eased);
        if (p < 1) requestAnimationFrame(tick);
      })(start);
    });
  }, { threshold: 0.5 });
  counters.forEach((c) => countObs.observe(c));

  /* ---------------------------------------------------------
     4. NAVIGASYON — yapışma, gizlenme, aktif bölüm
     --------------------------------------------------------- */
  const nav = $('#nav');
  const progress = $('#progress');
  let lastY = 0;

  function onScroll() {
    const y = window.scrollY;
    nav.classList.toggle('is-stuck', y > 40);
    nav.classList.toggle('is-hidden', y > 420 && y > lastY && !drawer.classList.contains('is-open'));
    lastY = y;

    const max = document.documentElement.scrollHeight - window.innerHeight;
    progress.style.transform = `scaleX(${max > 0 ? y / max : 0})`;
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  // aktif menü bağlantısı
  const navLinks = $$('.nav__links a');
  const sections = navLinks
    .map((a) => $(a.getAttribute('href')))
    .filter(Boolean);

  const sectionObs = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (!e.isIntersecting) return;
      navLinks.forEach((a) =>
        a.classList.toggle('is-current', a.getAttribute('href') === '#' + e.target.id)
      );
    });
  }, { rootMargin: '-45% 0px -50% 0px' });
  sections.forEach((s) => sectionObs.observe(s));

  /* ---------------------------------------------------------
     5. MOBİL MENÜ
     --------------------------------------------------------- */
  const burger = $('#burger');
  const drawer = $('#drawer');

  function setDrawer(open) {
    drawer.classList.toggle('is-open', open);
    burger.classList.toggle('is-open', open);
    burger.setAttribute('aria-expanded', String(open));
    drawer.setAttribute('aria-hidden', String(!open));
    burger.setAttribute('aria-label', open ? 'Menüyü kapat' : 'Menüyü aç');
    document.body.classList.toggle('is-locked', open);
  }
  burger.addEventListener('click', () => setDrawer(!drawer.classList.contains('is-open')));
  $$('.drawer__links a').forEach((a) => a.addEventListener('click', () => setDrawer(false)));
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && drawer.classList.contains('is-open')) setDrawer(false);
  });

  /* ---------------------------------------------------------
     6. HERO PARALAKSI + İMLEÇ IŞIĞI
     --------------------------------------------------------- */
  if (!reduced) {
    const par = $$('[data-parallax]');
    const wide = window.matchMedia('(min-width: 1081px)');
    let ticking = false;

    function clearParallax() {
      par.forEach((el) => { el.style.transform = ''; });
    }
    wide.addEventListener('change', () => { if (!wide.matches) clearParallax(); });

    window.addEventListener('scroll', () => {
      if (ticking || !wide.matches) return;
      ticking = true;
      requestAnimationFrame(() => {
        const y = window.scrollY;
        par.forEach((el) => {
          el.style.transform = `translate3d(0, ${y * parseFloat(el.dataset.parallax)}px, 0)`;
        });
        ticking = false;
      });
    }, { passive: true });

    const glow = $('#glow');
    let gx = 0, gy = 0, cx = 0, cy = 0, glowOn = false;
    window.addEventListener('pointermove', (e) => {
      if (e.pointerType !== 'mouse') return;
      gx = e.clientX; gy = e.clientY;
      if (!glowOn) { glowOn = true; glow.style.opacity = '.12'; cx = gx; cy = gy; }
    }, { passive: true });
    (function loop() {
      cx += (gx - cx) * 0.06;
      cy += (gy - cy) * 0.06;
      glow.style.transform = `translate3d(${cx}px, ${cy}px, 0)`;
      requestAnimationFrame(loop);
    })();
  }

  /* ---------------------------------------------------------
     7. RENK KONFİGÜRATÖRÜ
     --------------------------------------------------------- */
  const swatches   = $$('.sw');
  const viewers    = [$('#viewer'), $('#viewerMacro')];
  const colorName  = $('#colorName');
  const colorCode  = $('#colorCode');
  const colorDesc  = $('#colorDesc');
  const colorInfo  = $('.colors__info');
  const colorCta   = $('#colorCta');
  const colorField = $('#fColor');

  function hexToRgb(hex) {
    const h = hex.replace('#', '');
    return [0, 2, 4].map((i) => parseInt(h.substr(i, 2), 16));
  }

  const relLum = ([r, g, b]) => {
    const f = (c) => { c /= 255; return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4); };
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
  };

  function rgbToHsl([r, g, b]) {
    r /= 255; g /= 255; b /= 255;
    const max = Math.max(r, g, b), min = Math.min(r, g, b), d = max - min;
    const l = (max + min) / 2;
    if (!d) return [0, 0, l];
    const s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    let h;
    if (max === r) h = ((g - b) / d + (g < b ? 6 : 0));
    else if (max === g) h = (b - r) / d + 2;
    else h = (r - g) / d + 4;
    return [h / 6, s, l];
  }

  function hslToRgb([h, s, l]) {
    if (!s) { const v = Math.round(l * 255); return [v, v, v]; }
    const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    const p = 2 * l - q;
    const hue = (t) => {
      if (t < 0) t += 1;
      if (t > 1) t -= 1;
      if (t < 1 / 6) return p + (q - p) * 6 * t;
      if (t < 1 / 2) return q;
      if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    };
    return [hue(h + 1 / 3), hue(h), hue(h - 1 / 3)].map((c) => Math.round(c * 255));
  }

  // Koyu kumaş tonları (ör. Midnight Navy) siyah zeminde okunmuyor.
  // Kumaş rengi diskte ve fotoğrafta olduğu gibi kalır; arayüz vurgusu
  // yeterli kontrasta ulaşana kadar açılır — ton korunur, yalnızca
  // parlaklık yükselir, böylece lacivert grileşmez.
  function readable(hex, target = 0.34) {
    const base = hexToRgb(hex);
    if (relLum(base) >= target) return base;
    const [h, s0, l0] = rgbToHsl(base);
    const s = Math.min(1, Math.max(s0, 0.28));
    let l = l0, out = base;
    while (l < 0.95 && relLum(out) < target) {
      l += 0.02;
      out = hslToRgb([h, s, l]);
    }
    return out;
  }

  function applyColor(btn, scrollSync) {
    const { key, name, code, hex, desc } = btn.dataset;

    swatches.forEach((s) => {
      const on = s === btn;
      s.classList.toggle('is-active', on);
      s.setAttribute('aria-checked', String(on));
    });

    viewers.forEach((v) => {
      $$('.viewer__img', v).forEach((img) => img.classList.toggle('is-active', img.dataset.key === key));
    });

    // metin geçişi
    colorInfo.classList.add('is-swapping');
    setTimeout(() => {
      colorName.textContent = name;
      colorCode.textContent = code;
      colorDesc.textContent = desc;
      colorCta.textContent = `${name} ile ön sipariş ver`;
      colorInfo.classList.remove('is-swapping');
    }, reduced ? 0 : 260);

    // sayfa vurgu rengini güncelle
    const [r, g, b] = readable(hex);
    const root = document.documentElement.style;
    root.setProperty('--accent', `rgb(${r},${g},${b})`);
    root.setProperty('--accent-soft', `rgba(${r},${g},${b},.14)`);
    root.setProperty('--accent-glow-a', `rgba(${r},${g},${b},.10)`);
    root.setProperty('--accent-glow-b', `rgba(${r},${g},${b},.05)`);

    // forma işle
    if (colorField && colorField.value !== name) colorField.value = name;
    if (scrollSync) localStorage.setItem('qwet.color', key);
  }

  swatches.forEach((btn) => btn.addEventListener('click', () => applyColor(btn, true)));

  // form seçimi değişirse konfigüratörü de çevir
  colorField.addEventListener('change', () => {
    const match = swatches.find((s) => s.dataset.name === colorField.value);
    if (match) applyColor(match, true);
  });

  // önceki seçimi geri yükle
  const saved = localStorage.getItem('qwet.color');
  const savedBtn = saved && swatches.find((s) => s.dataset.key === saved);
  if (savedBtn) applyColor(savedBtn, false);

  /* ---------------------------------------------------------
     8. KONTENJAN ÇUBUĞU
     --------------------------------------------------------- */
  const stockBar = $('#stockBar');
  const stockCount = $('#stockCount');
  const sold = parseInt(stockCount.textContent, 10);
  const stockObs = new IntersectionObserver((entries) => {
    entries.forEach((e) => {
      if (!e.isIntersecting) return;
      stockObs.unobserve(e.target);
      stockBar.style.width = (sold / 500) * 100 + '%';
    });
  }, { threshold: 0.3 });
  stockObs.observe($('.order__stock'));

  /* ---------------------------------------------------------
     9. ÖN SİPARİŞ FORMU
     --------------------------------------------------------- */
  const UNIT = 13900;
  const form = $('#orderForm');
  const qtyInput = $('#fQty');
  const totalEl = $('#formTotal');
  const submitBtn = $('#submitBtn');
  const success = $('#success');
  const successCode = $('#successCode');
  const successMsg = $('#successMsg');
  const againBtn = $('#againBtn');

  const money = (n) => '₺' + n.toLocaleString('tr-TR');

  function clampQty() {
    let v = parseInt(qtyInput.value, 10);
    if (isNaN(v) || v < 1) v = 1;
    if (v > 10) v = 10;
    qtyInput.value = v;
    return v;
  }
  function updateTotal() {
    totalEl.textContent = money(UNIT * clampQty());
  }
  $$('.qty__btn').forEach((b) =>
    b.addEventListener('click', () => {
      qtyInput.value = clampQty() + parseInt(b.dataset.step, 10);
      updateTotal();
    })
  );
  qtyInput.addEventListener('input', updateTotal);
  qtyInput.addEventListener('blur', updateTotal);
  updateTotal();

  /* --- doğrulama --- */
  const rules = {
    fName:  (v) => (v.trim().length >= 3 ? '' : 'Lütfen ad ve soyadınızı yazın.'),
    fMail:  (v) => (/^[^\s@]+@[^\s@]+\.[a-zA-Z]{2,}$/.test(v.trim()) ? '' : 'Geçerli bir e‑posta adresi girin.'),
    fPhone: (v) => (v.replace(/\D/g, '').length >= 10 ? '' : 'En az 10 haneli telefon numarası girin.'),
    fCity:  (v) => (v ? '' : 'Şehir seçin.')
  };

  function validateField(id) {
    const el = $('#' + id);
    const wrap = el.closest('.field');
    const msg = rules[id](el.value);
    wrap.classList.toggle('is-bad', !!msg);
    const small = $('small', wrap);
    if (small) small.textContent = msg;
    return !msg;
  }

  Object.keys(rules).forEach((id) => {
    const el = $('#' + id);
    el.addEventListener('blur', () => validateField(id));
    el.addEventListener('input', () => {
      if (el.closest('.field').classList.contains('is-bad')) validateField(id);
    });
    el.addEventListener('change', () => validateField(id));
  });

  // telefon biçimlendirme (TR)
  $('#fPhone').addEventListener('input', (e) => {
    const d = e.target.value.replace(/\D/g, '').slice(0, 11);
    const p = d.startsWith('0') ? d.slice(1) : d;
    let out = '';
    if (p.length) out = '0' + p.slice(0, 3);
    if (p.length > 3) out += ' ' + p.slice(3, 6);
    if (p.length > 6) out += ' ' + p.slice(6, 8);
    if (p.length > 8) out += ' ' + p.slice(8, 10);
    e.target.value = out;
  });

  const kvkk = $('#fKvkk');
  kvkk.addEventListener('change', () => kvkk.closest('.check').classList.remove('is-bad'));

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const ok = Object.keys(rules).map(validateField).every(Boolean);
    const kvkkOk = kvkk.checked;
    kvkk.closest('.check').classList.toggle('is-bad', !kvkkOk);

    if (!ok || !kvkkOk) {
      const bad = $('.field.is-bad, .check.is-bad');
      if (bad) bad.scrollIntoView({ behavior: reduced ? 'auto' : 'smooth', block: 'center' });
      return;
    }

    submitBtn.classList.add('is-busy');
    submitBtn.disabled = true;

    const order = {
      kod: 'QWET‑' + Date.now().toString(36).toUpperCase().slice(-6),
      ad: $('#fName').value.trim(),
      eposta: $('#fMail').value.trim(),
      telefon: $('#fPhone').value.trim(),
      renk: $('#fColor').value,
      sehir: $('#fCity').value,
      kurulum: $('#fPlace').value,
      adet: clampQty(),
      not: $('#fNote').value.trim(),
      tutar: UNIT * clampQty(),
      tarih: new Date().toISOString()
    };

    // Burası gerçek uçla değiştirilecek (bkz. site/README.md)
    setTimeout(() => {
      try {
        const all = JSON.parse(localStorage.getItem('qwet.orders') || '[]');
        all.push(order);
        localStorage.setItem('qwet.orders', JSON.stringify(all));
      } catch (err) { /* depolama kapalı olabilir */ }

      successCode.textContent = order.kod;
      successMsg.textContent =
        `${order.ad.split(' ')[0]}, ${order.adet} adet ${order.renk} QWET için sıraya alındınız. ` +
        `Onay e‑postası ${order.eposta} adresine gönderildi.`;

      form.classList.add('is-gone');
      success.hidden = false;
      success.scrollIntoView({ behavior: reduced ? 'auto' : 'smooth', block: 'center' });

      submitBtn.classList.remove('is-busy');
      submitBtn.disabled = false;
    }, 900);
  });

  againBtn.addEventListener('click', () => {
    success.hidden = true;
    form.classList.remove('is-gone');
    form.reset();
    qtyInput.value = 1;
    updateTotal();
    $$('.field.is-bad').forEach((f) => f.classList.remove('is-bad'));
    const active = swatches.find((s) => s.classList.contains('is-active'));
    if (active) colorField.value = active.dataset.name;
    form.scrollIntoView({ behavior: reduced ? 'auto' : 'smooth', block: 'center' });
  });

  /* ---------------------------------------------------------
     10. SSS — aynı anda tek açık başlık
     --------------------------------------------------------- */
  const faqItems = $$('.faq details');
  faqItems.forEach((d) =>
    d.addEventListener('toggle', () => {
      if (d.open) faqItems.forEach((o) => { if (o !== d) o.open = false; });
    })
  );

  /* ---------------------------------------------------------
     11. YUMUŞAK KAYDIRMA (sabit başlık payıyla)
     --------------------------------------------------------- */
  $$('a[href^="#"]').forEach((a) => {
    a.addEventListener('click', (e) => {
      const id = a.getAttribute('href');
      if (id === '#' || id.length < 2) return;
      const target = $(id);
      if (!target) return;
      e.preventDefault();
      const top = target.getBoundingClientRect().top + window.scrollY - 76;
      window.scrollTo({ top, behavior: reduced ? 'auto' : 'smooth' });
    });
  });
})();
