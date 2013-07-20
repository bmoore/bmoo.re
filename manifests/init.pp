# Puppet Stages
stage {
    'users':      before => Stage['folders'];
    'folders':    before => Stage['repos'];
    'repos':      before => Stage['updates'];
    'updates':    before => Stage['packages'];
    'packages':   before => Stage['pipackages'];
    'pipackages': before => Stage['configure'];
    'configure':  before => Stage['services'];
    'services':   before => Stage['main'];
}

class users {
    group { "www-data":
        ensure => "present",
     }
}

class folders {
    file { ['/var/www', '/var/www/bmoore']:
        ensure => 'directory',
        owner => 'www-data',
        group => 'www-data',
        mode => 0755
    }
}

class repos {
}

class updates {
    exec { "aptitude-update":
        command => "/usr/bin/aptitude update -y -q",
        timeout => 0
    }
}

class packages {
    package {[
            "python",
            "python-dev",
            "python-pip",
            "postgresql",
            "libpq-dev"]:
        ensure => "present",
    }
}

class pipackages {
    exec {
        "flask":
            command => '/usr/bin/pip install Flask',
            cwd => '/var/www/bmoore';
        "flask-restful":
            command => '/usr/bin/pip install flask-restful',
            cwd => '/var/www/bmoore';
        "flask-sqlalchemy":
            command => '/usr/bin/pip install Flask-SQLAlchemy',
            cwd => '/var/www/bmoore';
        "psycopg2":
            command => '/usr/bin/pip install psycopg2',
            cwd => '/var/www/bmoore';
    }
}

class configure {
    exec {
        "postgres-test-user":
            command => '/usr/bin/sudo -u postgres psql -c "CREATE USER tester WITH SUPERUSER LOGIN PASSWORD \'tester\';"',
            cwd => '/var/www/bmoore',
            unless => '/usr/bin/sudo -u postgres psql -c "SELECT rolname FROM pg_roles WHERE rolname = \'tester\';" | grep tester';
        "postgres-test-db":
            command => '/usr/bin/sudo -u postgres psql -c "CREATE DATABASE tester OWNER tester;"',
            cwd => '/var/www/bmoore',
            unless => '/usr/bin/sudo -u postgres psql -c "SELECT datname FROM pg_database WHERE datname = \'tester\';" | grep tester';
    }
}

class services {
    exec {
        "demo-web":
            command => '/usr/bin/python bmoore.py 2> /var/www/bmoore/logs/flask.log &',
            cwd => '/var/www/bmoore'
    }
}

class {
    users:      stage => "users";
    repos:      stage => "repos";
    updates:    stage => "updates";
    pipackages: stage => "pipackages";
    packages:   stage => "packages";
    configure:  stage => "configure";
    services:   stage => "services";
}
