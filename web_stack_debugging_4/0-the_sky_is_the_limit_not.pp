# Raises system and Nginx file descriptor limits for high concurrency
exec { 'raise-file-limits':
  command  => '/bin/bash /tmp/tune_nginx.sh',
  provider => 'shell',
}
file { '/tmp/tune_nginx.sh':
  ensure  => file,
  mode    => '0755',
  content => "#!/usr/bin/env bash
ulimit -n 65536
sysctl -w fs.file-max=2097152 >/dev/null 2>&1 || true
sed -i 's/worker_connections .*/worker_connections 4096;/g' /etc/nginx/nginx.conf
grep -q 'worker_rlimit_nofile' /etc/nginx/nginx.conf || sed -i 's/worker_processes .*/worker_processes 4;\nworker_rlimit_nofile 65536;/g' /etc/nginx/nginx.conf
sed -i 's/\\* soft nofile .*/\\* soft nofile 65536/g; s/\\* hard nofile .*/\\* hard nofile 65536/g' /etc/security/limits.conf
service nginx restart
",
}
