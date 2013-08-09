class awstats::apache (
    $use_htpasswd = 'false'
) {
    include awstats

    file { "/etc/awstats/apache.conf":
        ensure  => present,
        source => 
            [ "puppet:///modules/site-awstats/${::fqdn}/apache.conf",
            "puppet:///modules/site-awstats/${::operatingsystem}/apache.conf",
            "puppet:///modules/site-awstats/apache.conf",
            "puppet:///modules/awstats/${::operatingsystem}/apache.conf",
            "puppet:///modules/awstats/apache.conf" ],
        owner   => root,
        group   => root,
        mode    => 0644,
        notify  => Exec["refresh_awstats"],
        require => Package["awstats"];
    }

    apache::config::global { "awstats.conf":
        ensure => link,
        target => "/etc/awstats/apache.conf",
        require => File["/etc/awstats/apache.conf"]
    }

    if $use_htpasswd {
        file { 'awstats_htpasswd':
            path => "/etc/awstats/htpasswd.users",
            source =>
                [ "puppet:///modules/site-awstats/${::fqdn}/htpasswd.users",
                "puppet:///modules/site-awstats/${::operatingsystem}/htpasswd.users",
                "puppet:///modules/site-awstats/htpasswd.users",
                "puppet:///modules/awstats/${::operatingsystem}/htpasswd.users",
                "puppet:///modules/awstats/htpasswd.users" ],
            require => Package['awstats'],
            mode => 0640, owner => root, group => www-data;
        }
    }
}
