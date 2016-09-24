cp ./mgenDistro.tgz /tmp
cd /tmp
rm -rf tagaMini
#rm -rf mgenDistro
tar zxvf mgenDistro.tgz 
cd mgenDistro
cp -r tagaMini ..

./tagaInstall.sh

