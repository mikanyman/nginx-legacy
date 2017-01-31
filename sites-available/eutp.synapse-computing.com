# eutp.synapse-computing.com
# conf. model: https://code.djangoproject.com/wiki/DjangoAndNginx

upstream django_eutp {
    server unix:///home/mnyman/.pyenv/versions/eutp-3.4.1/staging/eutp/eutp.sock;
    #server 127.0.0.1:8001;
}

server {

    listen 80;
    server_name eutp.synapse-computing.com;
    charset utf-8;
    client_max_body_size 2M;
    access_log /var/log/nginx/eutp-access.log;
    error_log /var/log/nginx/eutp-error.log;

    location /static/ { # STATIC_URL
        alias /home/mnyman/.pyenv/versions/eutp-3.4.1/staging/static/;
        expires 30d;
    }

    location /media/ { # MEDIA_URL
        alias /home/mnyman/.pyenv/versions/eutp-3.4.1/staging/media/;
        expires 30d;
    }

    location / {
        uwsgi_pass django_eutp;
        include /etc/nginx/uwsgi_params; # itse lisatty
    }
}

