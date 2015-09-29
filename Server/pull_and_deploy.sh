cd /home/ubuntu/git/Senior-Project/
git pull
cd Server/python/cgi-bin/
rm /home/ubuntu/cgi-bin/*.py
cp *.py /home/ubuntu/cgi-bin/
chmod 777 /home/ubuntu/cgi-bin/*.py
sudo apachectl restart
