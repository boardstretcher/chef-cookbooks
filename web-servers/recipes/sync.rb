# sync files from chef server
bash "sync_all_files" do
		code <<-EOH
			rsync -varh --delete --progress --exclude='*m.anywhere.conf*' chef01.lasvegas.website.lan:/home/so_software_repo/etc_httpd/ /etc/httpd/
			rsync -varh --delete --progress chef01.lasvegas.website.lan:/home/so_software_repo/home_dealreso_public_html/ /home/dealreso/public_html/
			rsync -varh --delete --progress chef01.lasvegas.website.lan:/home/so_software_repo/home_deploy/ /home/deploy/
			rsync -varh --delete --progress chef01.lasvegas.website.lan:/home/so_software_repo/usr_share_pear/ /usr/share/pear/
			rsync -varh --delete --progress chef01.lasvegas.website.lan:/home/so_software_repo/var_www/ /var/www/
		EOH
	end
	ignore_failure true
end

