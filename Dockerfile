FROM fpfis/httpd-php:production-7.1 AS build
ADD . /platform

FROM build AS cron
WORKDIR /platform/build
ENTRYPOINT [ "/platform/vendor/bin/drush", "cron" ]


FROM build AS updater
WORKDIR /platform/build
ENTRYPOINT [ "/platform/vendor/bin/drush", "updb -y" ]

FROM build AS installer
ENV MYSQL_HOST mysql
ENV MYSQL_DATABASE db_name
ENV MYSQL_USERNAME root
ENV MYSQL_PASSWORD ""
ENV MULTISITE_PROFILE "multisite_drupal_standard"
ENV MULTISITE_NAME    "Configure me Sensei"
WORKDIR /platform/build
ENTRYPOINT [
  "/platform/vendor/bin/drush",
  "--account-mail=\"admin@example.com\"",
  "--account-name=\"${MYSQL_USERNAME}\"",
  "--account-pass=\"${MYSQL_PASSOWRD}\"",
  "--db-url=\"mysql://root:@mysql:3306/db_name\"",
  "--root=\"/test/platform-dev/build\"",
  "--site-name=\"\"",
  "--yes",
  "site-install",
  "${MULTISITE_PROFILE}"
]


FROM fpfis/httpd-php:production-7.1 as webnode
COPY --from=build /platform/build /var/www/html
