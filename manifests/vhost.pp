define awstats::vhost
(
    $ensure = present,
    $domain = $name,
    $port = 80,
    $log_file
) {
    include awstats

    file { "/etc/awstats/awstats.${domain}.conf":
        ensure => $ensure,
        content => template("awstats/awstats.vhost.erb"),
        owner   => root,
        group   => root,
        mode    => 0644,
        notify  => Exec["refresh_awstats"]
    }
}
