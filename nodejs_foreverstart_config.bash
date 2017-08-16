1. apt-get install supervisor

2. cat >/etc/supervisor/conf.d/node-app.conf

[program:nodeapp]
directory=/home/a/www/TeamLink/
command=sudo forever start app.js
autostart=true
autorestart=true
user=a
environment=HOME="/home/nodeapp",USER="a",NODE_ENV="production"
stdout_logfile=syslog
stderr_logfile=syslog


3.supervisorctl reread
4.supervisorctl update