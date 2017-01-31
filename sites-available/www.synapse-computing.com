# www.synapse-computing.com
# conf. model: https://code.djangoproject.com/wiki/DjangoAndNginx

upstream django_synapse {
    server unix:///home/mnyman/.pyenv/versions/synapse-3.4.1/staging/synapse/synapse.sock;
    #server 127.0.0.1:8001;
}

server {

    listen 80;
    server_name www.synapse-computing.com;
    charset utf-8;
    client_max_body_size 2M;
    access_log /var/log/nginx/synapse-access.log;
    error_log /var/log/nginx/synapse-error.log;

    location /static/ { # STATIC_URL
        alias /home/mnyman/.pyenv/versions/synapse-3.4.1/staging/static/;
        expires 30d;
    }

    location /media/ { # MEDIA_URL
        alias /home/mnyman/.pyenv/versions/synapse-3.4.1/staging/media/;
        expires 30d;
    }

    #location / {
    #    uwsgi_pass unix:///run/uwsgi/app/synapse/socket;
    #    include /etc/nginx/uwsgi_params; # itse lisatty
    #}

    #location / {
    #    include /etc/nginx/uwsgi_params; # itse lisatty
    #    uwsgi_pass 127.0.0.1:3031;
    #}

    location / {
        uwsgi_pass django_synapse;
        include /etc/nginx/uwsgi_params; # itse lisatty
    }
}

