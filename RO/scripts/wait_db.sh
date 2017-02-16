#!/bin/bash

while ! mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" --silent; do
	echo "Wait for MySQL Server ${DB_HOST}:${DB_PORT}"
    sleep 1
done