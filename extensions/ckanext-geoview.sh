#!/bin/bash

. /usr/lib/ckan/default/bin/activate

echo "======================================"
echo "Installing geoview extension..."

python -m pip install -e "git+https://github.com/ckan/ckanext-geoview.git@v0.0.20#egg=ckanext-geoview"

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.plugins' \
                                         'resource_proxy'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.plugins' \
                                         'geojson_view'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.views.default_views' \
                                         'geojson_view'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.plugins' \
                                         'geo_view'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.views.default_views' \
                                         'geo_view'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.views.default_views' \
                                         'geo_view'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckanext.geoview.ol_viewer.default_feature_hoveron' \
                                         'true'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckanext.geoview.ol_viewer.formats' \
                                         'wms'
