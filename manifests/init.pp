class awstats(
    $use_cron     = false,
    $cron_user    = 'root',
    $cron_minute = [1],
    $cron_hour   = undef,
) inherits ::awstats::params {
    package { "awstats":
        ensure => installed
    }
    
    exec { "refresh_awstats":
        command => "${::awstats::params::awstats_updateall} now -awstatsprog=${::awstats::params::awstats}",
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
    
    $cron_ensure = $use_cron ? {
      true  => 'present',
      false => 'absent'
    }
    cron { "awstats":
        ensure  => $cron_ensure,
        command => "${::awstats::params::awstats_updateall} now -awstatsprog=${::awstats::params::awstats}",
        user    => $cron_user,
        minute  => $cron_minute,
        hour    => $cron_hour,
    }
}
