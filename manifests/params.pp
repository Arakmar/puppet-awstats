class awstats::params {

    case $::osfamily {
        'RedHat': {
            $awstats_buildstaticpages = '/usr/bin/awstats_buildstaticpages.pl'
            $awstats_updateall = '/usr/bin/awstats_updateall.pl'
            $awstats = '/var/www/awstats/awstats.pl'
        }
        'Debian': {
            $awstats_buildstaticpages = '/usr/share/awstats/tools/awstats_buildstaticpages.pl'
            $awstats_updateall = '/usr/share/doc/awstats/examples/awstats_updateall.pl'
            $awstats = '/usr/lib/cgi-bin/awstats.pl'
        }
        default: {
            $awstats_buildstaticpages = '/usr/share/awstats/tools/awstats_buildstaticpages.pl'
            $awstats = '/usr/lib/cgi-bin/awstats.pl'
        }
    }
} 
