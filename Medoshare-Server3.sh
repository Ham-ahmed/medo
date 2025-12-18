#!/bin/sh

cd /tmp
set -e

# تحميل الملف
wget "https://raw.githubusercontent.com/Ham-ahmed/medo/main/Medoshare-Server3.tar.gz"

# فك الضغط
tar -xzf Medoshare-Server3.tar.gz -C /

# تنظيف الملف المؤقت
rm -f /tmp/Medoshare-Server3.tar.gz

sleep 2
echo ""
echo ""
echo "**************************************************"
echo "#           INSTALLED SUCCESSFULLY              #"
echo "*           MagicPanelpro v6.5                  *"
echo "*     Enigma2 restart is required               *"
echo "**************************************************"
echo "        UPLOADED BY  >>>>   HAMDY_AHMED          "
echo "**************************************************"

# إعادة تشغيل Enigma2
killall -9 enigma2
exit 0