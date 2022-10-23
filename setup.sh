#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get install -y crudini

echo "======================================"
echo "Installing CKAN into a Python virtual environment..."

python3 -m venv /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate
python -m pip install setuptools==44.1.0
python -m pip install --upgrade pip

python -m pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.9.5#egg=ckan[requirements,dev]'

echo "Setting up a PostgreSQL database..."

sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD 'test1234';"
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8

echo "Creating a CKAN config file..."

ckan generate config /etc/ckan/default/ckan.ini

crudini --inplace --set '/etc/ckan/default/ckan.ini' \
                        'app:main' \
                        'ckan.site_url' \
                        'http://192.168.33.60:5000'

sed -i 's/ckan_default:pass/ckan_default:test1234/g' /etc/ckan/default/ckan.ini

echo "Setting up Solr..."

sed -i 's/port="8080"/port="8983"/g' /etc/tomcat9/server.xml
mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
crudini --inplace --set '/etc/ckan/default/ckan.ini' \
                        'app:main' \
                        'solr_url' \
                        'http://127.0.0.1:8983/solr'
service tomcat9 restart

echo "Linking to who.ini..."

ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

echo "Creating database tables..."

ckan -c /etc/ckan/default/ckan.ini db init

echo "Configuring FileStore..."

mkdir -p /var/lib/ckan/default
crudini --inplace --set '/etc/ckan/default/ckan.ini' \
                        'app:main' \
                        'ckan.storage_path' \
                        '/var/lib/ckan/default'

chown -R vagrant /var/lib/ckan/default
chmod u+rwx /var/lib/ckan/default

echo "Setting up DataStore..."

sudo -u postgres psql -c "CREATE USER datastore_default WITH PASSWORD 'test1234';"
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.plugins' \
                                         'datastore'
crudini --inplace --set '/etc/ckan/default/ckan.ini' \
                   'app:main' \
                   'ckan.datastore.write_url' \
                   'postgresql://ckan_default:test1234@localhost/datastore_default'
crudini --inplace --set '/etc/ckan/default/ckan.ini' \
                    'app:main' \
                    'ckan.datastore.read_url' \
                    'postgresql://datastore_default:test1234@localhost/datastore_default'                                         
ckan -c /etc/ckan/default/ckan.ini datastore set-permissions | sudo -u postgres psql --set ON_ERROR_STOP=1

echo "Creating a sysadmin user..."

ckan -c /etc/ckan/default/ckan.ini user add admin email=admin@localhost password=test1234
ckan -c /etc/ckan/default/ckan.ini sysadmin add admin

echo "======================================"
echo "Installing custom extension..."

python -m pip install -e '/home/vagrant/project'

crudini --inplace --set --list --list-sep=' ' '/etc/ckan/default/ckan.ini' \
                                         'app:main' \
                                         'ckan.plugins' \
                                         $CKAN_PLUGIN
