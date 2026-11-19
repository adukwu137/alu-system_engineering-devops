# Raises Nginx ULIMIT and worker connections to eliminate failed requests
exec { 'set-nginx-ulimit':
  command => 'sed -i "s/ULIMIT=.*/ULIMIT=\\"-n 4096\\"/" /etc/default/nginx',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
exec { 'set-nginx-workers':
  command => 'sed -i "s/worker_connections .*/worker_connections 4096;/" /etc/nginx/nginx.conf',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
exec { 'restart-nginx':
  command => 'service nginx restart',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  require => [Exec['set-nginx-ulimit'], Exec['set-nginx-workers']],
}
