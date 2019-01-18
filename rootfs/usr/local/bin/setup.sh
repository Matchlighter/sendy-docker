#!/bin/bash

echo "[INFO] Setting up container"

APP_PATH=${APP_PATH:-}

DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-sendy}
DB_USER=${DB_USER:-sendy}
DB_PASSWORD=${DB_PASSWORD:-}
DB_CHARSET=${DB_CHARSET:-utf8mb4}

COOKIE_DOMAIN=${COOKIE_DOMAIN:-}

# SENDY CONFIG
# ---------------------------------------------------------------------------------------------

cat > /var/www/html/includes/config.php <<-EOF
	<?php
	  //----------------------------------------------------------------------------------//
	  //                               COMPULSORY SETTINGS
	  //----------------------------------------------------------------------------------//

	  /*  Set the URL to your Sendy installation (without the trailing slash) */
	  define('APP_PATH', '${APP_PATH}');

	  /*  MySQL database connection credentials (please place values between the apostrophes) */
	  \$dbHost = '${DB_HOST}'; //MySQL Hostname
	  \$dbUser = '${DB_USER}'; //MySQL Username
	  \$dbPass = '${DB_PASSWORD}'; //MySQL Password
	  \$dbName = '${DB_NAME}'; //MySQL Database Name


	  //----------------------------------------------------------------------------------//
	  //                               OPTIONAL SETTINGS
	  //----------------------------------------------------------------------------------//

	  /*
	    Change the database character set to something that supports the language you'll
	    be using. Example, set this to utf16 if you use Chinese or Vietnamese characters
	  */
	  \$charset = '${DB_CHARSET}';

	  /*  Set this if you use a non standard MySQL port.  */
	  \$dbPort = ${DB_PORT};

	  /*  Domain of cookie (99.99% chance you don't need to edit this at all)  */
	  define('COOKIE_DOMAIN', '${COOKIE_DOMAIN}');

	  //----------------------------------------------------------------------------------//
	?>
EOF

# S6 WATCHDOG
# ---------------------------------------------------------------------------------------------

mkdir -p /tmp/counters

for service in _parent cron apache; do

	# Init process counters
	echo 0 > /tmp/counters/$service

	# Create a finish script for all services
	cat > /services/$service/finish <<-EOF
		#!/bin/bash
		# $1 = exit code from the run script
		if [ "\$1" -eq 0 ]; then
		  # Send a SIGTERM and do not restart the service
		  logger -p local0.info "s6-supervise : stopping ${service} process"
		  s6-svc -d /services/${service}
		else
		  COUNTER=\$((\$(cat /tmp/counters/${service})+1))
		  if [ "\$COUNTER" -ge 20 ]; then
		    # Permanent failure for the service, s6-supervise does not restart it
		    logger -p local0.err "s6-supervise : ${service} has restarted too many times (permanent failure)"
		    exit 125
		  else
		    echo "\$COUNTER" > /tmp/counters/${service}
		  fi
		fi
		exit 0
	EOF
done

chmod +x /services/*/finish

echo "[INFO] Finished container setup"
