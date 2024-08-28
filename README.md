قبل از اجرا اسکریپت لازمه یه فایل کانفیگ تنظمم کنید [فایل کانفیگ نمونه](https://github.com/xmohammad1/steupnode/blob/main/config.cfg)
# Method 1
داخل سرور فایل کانفیگ خودتونو بزارید
```
nano /root/config.cfg
```
```
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/go.sh)
```

# Method 2
 جلو لینک اسکریپت لینک فایل config.cfg که تنظیم کردید رو بزارید


 مثال:
```
bash <(curl -LS https://raw.githubusercontent.com/xmohammad1/steupnode/main/go.sh) https://raw.githubusercontent.com/xmohammad1/steupnode/main/config.cfg
```
