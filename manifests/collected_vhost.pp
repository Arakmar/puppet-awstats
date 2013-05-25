define awstats::collect_conf()
{
	Awstats::Add_vhost <<| tag == $name |>>
}
