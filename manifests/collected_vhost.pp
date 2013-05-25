define awstats::collected_vhost()
{
	Awstats::Add_vhost <<| tag == $name |>>
}
