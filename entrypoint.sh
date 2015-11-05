#!/bin/bash
set -e

case "$1" in
    web)
        (cd ..; alembic upgrade head)
        python -m gitmostwanted.web
        ;;

    celery)
        unlink /tmp/celery.pid &> /dev/null
        celery worker --app=gitmostwanted.app.celery --beat --purge \
            --events --logfile=/tmp/celery.log --loglevel=DEBUG \
            --pidfile=/tmp/celery.pid --schedule=/tmp/celerybeat-schedule.dat
        ;;

    *)
        echo $"Usage: $0 {web|celery}"
        exit 1
esac
