name             'thruk'
maintainer       'Martha Greenberg'
maintainer_email 'marthag@mit.edu'
license          'Apache 2.0'
description      'Installs/Configures thruk'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

depends 'yum-epel'
depends 'apache2'

supports 'centos'
supports 'debian'
