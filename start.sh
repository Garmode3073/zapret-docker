#!/bin/sh

# NET_ADMIN izin kontrolü
check_net_admin() {
	# kontrol için dummy bir iptables komutu
    iptables -L >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}
if check_net_admin; then
    echo "NET_ADMIN izni mevcut. install_easy.sh çalıştırılıyor..."
else
    echo "!!! ERROR: NET_ADMIN izni yok. Lütfen container'ı --cap-add=NET_ADMIN ile başlatın."
    exit 1
fi

# Domain listesi
if [ -n "$ZAPRET_DOMAINS" ]; then
    echo "$ZAPRET_DOMAINS" | tr ',' '\n' > ./ipset/zapret-hosts-user.txt
else
    echo "!!! Uyarı: ZAPRET_DOMAINS değişkeni tanımlı değil. Lütfen ekleyin."
    exit 1
fi

if [ -f /first_run ]; then
  echo "install_easy.sh çalıştırılıyor..."
  printf "Y\n\n\n3\n\n\nY\n\n\n\n\n\n" | /opt/zapret/install_easy.sh
  rm /first_run
fi

# Kurallar:
if [ -n "$ZAPRET_PARAMS" ]; then
    sed -i '/^NFQWS_OPT="/,/^"/c NFQWS_OPT="$ZAPRET_PARAMS"' /opt/zapret/config
else
    echo "!!! Uyarı: ZAPRET_PARAMS değişkeni tanımlı değil. Lütfen çıktıdan birisini seçip kullanın."
    printf "%s\n\n\n\n\n\n\n\n" "$(echo $ZAPRET_DOMAINS | cut -d "," -f 1)" | /opt/zapret/blockcheck.sh
    exit 1
fi

/opt/zapret/init.d/sysv/zapret start

/usr/bin/tinyproxy -d