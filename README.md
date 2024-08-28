قبل از اجرا اسکریپت لازمه یه فایل کانفیگ تنظیم کنید [فایل کانفیگ نمونه](https://github.com/xmohammad1/steupnode/blob/main/config.cfg)
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
