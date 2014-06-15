define awstats::vhost
(
    $ensure = present,
    $domain = $name,
    $port = 80,
    $host_aliases = "${domain}:${port}",
    $log_file,
    $log_type = 'W',
    $dir_data = "/var/lib/awstats",
    $use_static_pages = false,
    $use_cron = false,
    $cron_user    = 'root',
    $cron_minute = [1],
    $cron_hour   = undef,
) {
    if ! defined(Class['awstats']) {
        fail('You must include the awstats base class before using any awstats defined resources')
    }

    file { "/etc/awstats/awstats.${domain}:${port}.conf":
        ensure => $ensure,
        content => template("awstats/awstats.vhost.erb"),
        owner   => root,
        group   => root,
        mode    => 0644,
    }
    
    if $use_cron and $use_static_pages {
        $cron_ensure = 'present'
    } else {
        $cron_ensure = 'absent'
    }
    
    cron { "awstats_${domain}:${port}":
        ensure  => $cron_ensure,
        command => "${::awstats::params::awstats_buildstaticpages} -config=${domain} -update -awstatsprog=${::awstats::params::awstats} -dir=${dir_data}",
        user    => $cron_user,
        minute  => $cron_minute,
        hour    => $cron_hour,
    }

    if $use_static_pages {
        File[ "/etc/awstats/awstats.${domain}:${port}.conf"] {
            notify  => Exec["refresh_awstats_${domain}:${port}"]
        }
        exec { "refresh_awstats_${domain}:${port}":
            command => "${::awstats::params::awstats_buildstaticpages} -config=${domain} -update -awstatsprog=${::awstats::params::awstats} -dir=${dir_data}",
            refreshonly => true
        }
    }
}
