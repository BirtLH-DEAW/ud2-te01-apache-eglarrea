#Obtenemos la imagen de ubuntu apache
FROM ubuntu/apache2

#Actualizamos los paquetes e instalamos ssl
RUN apt-get update && apt-get install openssl

#Instalamos nano
RUN apt-get install nano

#Generamos el genpkey 
RUN openssl genpkey -algorithm RSA  -out /etc/ssl/private/ssl-cert-snakeoil.key
#Generamos la clave publica 
RUN openssl req -new -key /etc/ssl/private/ssl-cert-snakeoil.key -x509 -days 365 -out /etc/ssl/certs/ssl-cert-snakeoil.pem  -subj "/C=ES/ST=Bizkaiz/L=Bizkaia/O=Egoitz Larrea Manzano/OU=Birt/CN=www.eglarrea-birt.eus" 

#Activamos el modulo ssl y el sitio ssl
RUN a2enmod ssl
RUN a2ensite default-ssl.conf

#Copiamos las configuraciones de apache y los sitios
COPY apache2.conf /etc/apache2/apache2.conf
COPY ./sites-enabled/ /etc/apache2/sites-available/

#creamos la estructura de carpeta y copiamos el contenido
RUN mkdir -p /var/www/eglarrea/privado
COPY ["./Deafult website", "/var/www/html/"]
COPY ["./Private folder", "/var/www/eglarrea/privado/"]
COPY ["./User website/", "/var/www/eglarrea/"]


#Creamos el usuario y pass
RUN htpasswd -cb /etc/apache2/.htpasswd deaw deaw

EXPOSE 443
