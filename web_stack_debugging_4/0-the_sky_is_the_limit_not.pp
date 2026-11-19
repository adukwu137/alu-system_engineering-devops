# Raises Nginx ULIMIT and worker connections to eliminate failed requests
exec { 'fix-nginx-limit':
  command => 'python3 -c "import re; p=open(\"/etc/default/nginx\").read(); open(\"/etc/default/nginx\",\"w\").write(re.sub(r\"ULIMIT=.*\",\"ULIMIT=\\\"-n 4096\\\"\",p)); c=open(\"/etc/nginx/nginx.conf\").read(); open(\"/etc/nginx/nginx.conf\",\"w\").write(re.sub(r\"worker_connections .*;\",\"worker_connections 4096;\",c))"',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
exec { 'restart-nginx':
  command => 'service nginx restart',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  require => Exec['fix-nginx-limit'],
}
