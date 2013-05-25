define awstats::collected_vhost()
{
	Awstats::Vhost <<| tag == $name |>>
}
