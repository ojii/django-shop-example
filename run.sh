#!/bin/bash

if [ ! -f bootstrap.py ]; then
    if which wget &> /dev/null; then
        wget http://svn.zope.org/*checkout*/zc.buildout/trunk/bootstrap/bootstrap.py
    else
        curl http://svn.zope.org/*checkout*/zc.buildout/trunk/bootstrap/bootstrap.py > bootstrap.py
    fi
fi

if [ ! -f bin/buildout ]; then
    python bootstrap.py
fi

if [ ! -f bin/django ]; then
    bin/buildout
    
    bin/django syncdb --all
    bin/django migrate --fake
fi

function openbrowser {
    lsof -i :8000 &> /dev/null  
    loaded=$?
    while [ $loaded != 0 ]; do
        sleep 1
        lsof -i :8000 &> /dev/null
        loaded=$?
    done
    if which x-www-browser &> /dev/null; then 
        x-www-browser http://localhost:8000
    else
        open http://localhost:8000
    fi
}

openbrowser &
bin/django runserver