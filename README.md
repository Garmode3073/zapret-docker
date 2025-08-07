# Zapret Docker
[zapret](https://github.com/bol-van/zapret) için çalışacağı siteler ve parametreler ayarlanabilir Tinyproxy ve Debian Trixie tabanlı Docker konteyneri.

## Kullanım:
* [stack.env](https://github.com/ma-tecik/zapret-docker/stack.env) dosyasını indirip kendinize göre düzenleyin:
    * ZAPRET_DOMAINS: virgülle ayrılmış domain listesi, zapret bu siteler için çalışacak.  
    * ZAPRET_PARAMS: Zapret parametreleri, eğer boşsa ilk çalıştırmada seçebileceğiniz parametreler konteyner log'una yazılacak, kontrol ederek seçebilirsiniz.
* Ardından imajı çalıştırın:  
  * `docker run --name zapret -p 8888:8888 --cap-add=NET_ADMIN --env-file stack.env matecik/zapret` veya Docker compose [dosyası](https://github.com/ma-tecik/zapret-docker/compose.yaml) ile.
* Cihaz(lar)ınızda http proxy ayarlayın:
  * port: 8888

## stack.env açıklamaları:
### ZAPRET_DOMAINS:
`malum-site.com,malum-site2.com,malum-site3.net` ...
### ZAPRET_PARAMS:
* Gereğinden fazla parametre seçmeyin, çalışan en az seçim en iyisidir.
* Sadece `curl_test_https_tls12 : nfqws` parametrelerden seçim yapın, sistem nfqws üzerine kurulu.
* Daha fazla bilgi için [dökümantasyon](https://github.com/bol-van/zapret/blob/master/docs/readme.en.md#nfqws)


## Diğer bilgiler:
Dökümantasyon: [zapret docs](https://github.com/bol-van/zapret/blob/master/docs/readme.en.md)