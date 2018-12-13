# sync files from chef server
bash "sync_all_files" do
		code <<-EOH
			rsync -varh --delete --progress --exclude='*m.anywhere.conf*' chef01.lasvegas.website.lan:/home/so_software_repo/etc_httpd/ /etc/httpd/
		EOH
	ignore_failure true
end

