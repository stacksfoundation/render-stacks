FROM nginx:alpine
COPY configs/nginx.conf /etc/nginx/templates/default.conf.template 
