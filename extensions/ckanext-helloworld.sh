#!/bin/bash

. /usr/lib/ckan/default/bin/activate

echo "======================================"
echo "Installing custom extension..."

python -m pip install -e '/usr/lib/ckan/default/src/ckanext-helloworld'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.plugins' \
                                         'hello'
