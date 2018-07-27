# Used as base for other images
FROM fpfis/httpd-php:production-7.1 AS build
ADD . /platform

# Ever want to run drush cron or solr-index or redis-cli ? Here it is
FROM build AS worker
RUN rm /var/var/html -Rf && ln -s /platform/build /var/www/html
WORKDIR /var/www/html
ENTRYPOINT [ "/platform/vendor/bin/drush", "-r", "/var/www/html" ]

# Push this image on first run with secrets to install the site
FROM worker AS installer
ENV MYSQL_HOST mysql
ENV MYSQL_DATABASE db_name
ENV MYSQL_USERNAME root
ENV MYSQL_PASSWORD ""
ENV DRUPAL_EMAIL "digit-fpfis-support@ec.europa.eu"
ENV DRUPAL_USERNAME admin
ENV DRUPAL_PASSWORD Ch4ng3meSenSe1
ENV DRUPAL_NAME    "Configure me Sensei"
ENV MULTISITE_PROFILE "multisite_drupal_standard"
ENTRYPOINT [ "/platform/vendor/bin/drush", "--account-mail=\"${DRUPAL_EMAIL}\"", "--account-name=\"${DRUPAL_USERNAME}\"", "--account-pass=\"\"${DRUPAL_PASSWORD}}", "--db-url=\"mysql://${MYSQL_USERNAME}:${MYSQL_PASSOWRD}@${MYSQL_HOST}:3306/${MYSQL_DATABASE}\"", "--root=\"/var/www/html\"", "--site-name=\"${DRUPAL_NAME}\"", "--yes", "site-install", "${MULTISITE_PROFILE}" ]

# That should be the ... web nodes
FROM fpfis/httpd-php:production-7.1 as webnode
COPY --from=build /platform/build /var/www/html