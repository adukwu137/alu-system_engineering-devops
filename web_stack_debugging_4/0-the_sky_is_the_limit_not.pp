# Raises file descriptor limits and restarts Nginx so high-concurrency requests succeed
exec { 'raise-file-limits':
  command => 'sed -i "s/ulimit -n .*/ulimit -n 65536/g" /etc/default/nginx; sysctl -w fs.file-max=2097152 >/dev/null 2>&1 || true; sed -i "s/worker_connections .*/worker_connections 4096;/g" /etc/nginx/nginx.conf; service nginx restart',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
