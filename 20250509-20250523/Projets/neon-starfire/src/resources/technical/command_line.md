# To start web export
docker run -dit --name my-apache-app -p 8080:80 -v ~/web:/usr/local/apache2/htdocs/ httpd:2.4.63