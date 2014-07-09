yum_repository 'rsyslog_v7' do
	name "Adiscon-CentOS"
	baseurl "http://rpms.adiscon.com/v7-stable/epel-6/$basearch"
	enabled = true
	gpgcheck = false
	sslchek = false
	gpgkey "http://rpms.adiscon.com/RPM-GPG-KEY-Adiscon"
	action :create
end
