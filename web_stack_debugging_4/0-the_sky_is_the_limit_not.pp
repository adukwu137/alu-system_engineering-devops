# Raises file descriptor limits and worker connections for Nginx concurrency
file { '/usr/local/bin/fix_nginx.py':
  ensure  => file,
  mode    => '0755',
  content => "#!/usr/bin/env python3\n\
import re\n\
p = '/etc/default/nginx'\n\
open(p, 'w').write(re.sub(r'ULIMIT=.*', 'ULIMIT=\"-n 4096\"', open(p).read()))\n",
}
exec { 'set-nginx-ulimit':
  command => '/usr/local/bin/fix_nginx.py',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  require => File['/usr/local/bin/fix_nginx.py'],
}
exec { 'set-nginx-rlimit':
  command => 'sed -i "s/worker_processes .*/worker_processes 4;\\nworker_rlimit_nofile 65536;/" /etc/nginx/nginx.conf',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
exec { 'set-nginx-workers':
  command => 'sed -i "s/worker_connections .*/worker_connections 4096;/" /etc/nginx/nginx.conf',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
exec { 'restart-nginx':
  command => 'service nginx restart',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  require => [Exec['set-nginx-ulimit'], Exec['set-nginx-rlimit'], Exec['set-nginx-workers']],
}
