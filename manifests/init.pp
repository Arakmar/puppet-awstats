class awstats {
    package { "awstats":
        ensure => installed
    }
    
    exec { "refresh_awstats":
        command => 'perl /usr/share/doc/awstats/examples/awstats_updateall.pl now -awstatsprog=/usr/lib/cgi-bin/awstats.pl',
        refreshonly => true
    }
    
    file {
        "/etc/awstats/awstats.conf":
            ensure  => present,
            source => 
                [ "puppet:///modules/site-awstats/${::fqdn}/awstats.conf",
                "puppet:///modules/site-awstats/${::operatingsystem}/awstats.conf",
                "puppet:///modules/site-awstats/awstats.conf",
                "puppet:///modules/awstats/${::operatingsystem}/awstats.conf",
                "puppet:///modules/awstats/awstats.conf" ],
            owner   => root,
            group   => root,
            mode    => 0644,
            notify  => Exec["refresh_awstats"],
            require => Package["awstats"];
        "/etc/awstats/awstats.conf.local":
            ensure  => present,
            source => 
                [ "puppet:///modules/site-awstats/${::fqdn}/awstats.conf.local",
                "puppet:///modules/site-awstats/${::operatingsystem}/awstats.conf.local",
                "puppet:///modules/site-awstats/awstats.conf.local",
                "puppet:///modules/awstats/${::operatingsystem}/awstats.conf.local",
                "puppet:///modules/awstats/awstats.local" ],
            owner   => root,
            group   => root,
            mode    => 0644,
            notify  => Exec["refresh_awstats"],
            require => Package["awstats"];
        "/etc/awstats":
            ensure  => directory,
            owner   => root,
            group   => root,
            mode    => 0755,
            force   => true,
            recurse => true,
            purge   => true,
            notify  => Exec["refresh_awstats"],
            require => Package["awstats"];
    }
}
