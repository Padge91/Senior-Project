cd /home/ubuntu/git/Senior-Project/Server/python/cgi-bin/
git pull
rm ~/cgi-bin/*.py
cp *.py ~/cgi-bin/
chmod 777 ~/cgi-bin/*.py
sudo apachectl restart
