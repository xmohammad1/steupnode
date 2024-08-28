# ویژگی ها
کاربر به دلخواه خودش میتونه هر ویژگی که خواست رو خاموش یا روشن کنه داخل فایل کانفیگ
- اپدیت و اپگرید سرور
- تنظیم BBR و sysctl.conf
- نصب وارپ IPv6
- نصب linux security
- تنظیم DNS
- فعال سازی سرور نود فقط با دادن certficate از پنل
- فرایند بدون وقفه ( در صورت که از ssh اتصالتون قطع بشه فرایند نصب به مشکل نمیخوره)
- استفاده سریع و اسان تنها با یه کامند تک خطی میتونید فرایند نصب رو شروع کنید

# توضیح
قبل از اجرا اسکریپت لازمه یه فایل کانفیگ تنظیم کنید
[فایل کانفیگ نمونه](https://github.com/xmohammad1/steupnode/blob/main/config.cfg)


# روش اول
داخل سرور فایل کانفیگ خودتونو بزارید
```
nano /root/config.cfg
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
# روش سوم
نصب با حالت پیشفرض: تو این روش لازم نیست فایل کانفیگ تنظیم کنید فقط
اول اسکریپتو اجرا کنید و بعد فقط certificate از داخل پنل کپی کنید و بدید بهش
```
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/go.sh)
```
