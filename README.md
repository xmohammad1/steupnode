# ویژگی ها
کاربر به دلخواه خودش میتونه هر ویژگی که خواست رو خاموش یا روشن کنه داخل فایل کانفیگ
- اپدیت و اپگرید سرور
- تنظیم BBR و sysctl.conf ( بهبود سرعت و کارایی )
- نصب وارپ IPv6 ( رفع ارور 403 گوگل و یه سری سایت )
- نصب linux security ( افزایش امنیت سرور با تغییر پورت ssh و بلاک کردن ICMP )
- بلاک کردن سایت های ایرانی
- تنظیم DNS
- فعال سازی سرور نود فقط با دادن certficate از پنل
- فرایند بدون وقفه ( در صورت که از ssh اتصالتون قطع بشه فرایند نصب به مشکل نمیخوره و تا پایان پیش میره)
- استفاده سریع و اسان تنها با یه کامند تک خطی میتونید فرایند نصب رو شروع کنید

# توضیح
قبل از اجرا اسکریپت لازمه یه فایل کانفیگ تنظیم کنید
[فایل کانفیگ نمونه](https://github.com/xmohammad1/steupnode/blob/main/config.cfg)



**برای راه اندازی میتونید با یکی از روش های زیر پیش برید**
# روش اول
داخل سرور فایل کانفیگ خودتونو بزارید
```
nano /root/config.cfg
```
کانفیگو به دلخواه تنظیم کنید 
دقت کنید داخل "Your Main Panel Cert here" باید از پنل cert بگیرید برای نودتون و قرار بدید
```
# Enable bbr (yes / no)
install_bbr=yes

# Block Iranian Websites (yes / no)
Block_IR=no

# Install Linxux security (yes / no)
instsll_security=no

# install WARP IPv6 (yes / no)
WARP_IPv6=no
WARP_License=""

# Set DNS (yes / no)
set_dns=yes
# DNS Nameservers
DNS_CONTENT="
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 127.0.0.53
"
######   node configs  ######
CERT_CONTENT="
Your Main Panel Cert here
"
# leave it empty or put a version like v1.8.24
xray_version=""
#ports
Node_SERVICE_PORT=62050
Node_XRAY_API_PORT=62051
```
و بعد اسکریپتو اجرا کنید
```
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/go.sh)
```

# روش دوم
 جلو لینک اسکریپت لینک فایل config.cfg که تنظیم کردید رو بزارید


 مثال:
```
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/go.sh) https://raw.githubusercontent.com/xmohammad1/steupnode/main/config.cfg
```
