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

port=8000
lsof -i :$port &> /dev/null
statuscode=$?

while [ $statuscode == 0 ]; do
    let port=$port+1
    lsof -i :$port &> /dev/null
    statuscode=$?
done

function openbrowser {
    lsof -i :$port &> /dev/null  
    loaded=$?
    while [ $loaded != 0 ]; do
        sleep 1
        lsof -i :$port &> /dev/null
        loaded=$?
    done
    if which x-www-browser &> /dev/null; then 
        x-www-browser http://localhost:$port
    else
        open http://localhost:$port
    fi
}

openbrowser &
bin/django runserver 127.0.0.1:$port
