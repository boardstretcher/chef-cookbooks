# how to pull down oracle java using chef
# NO EASY FEAT I TELL YOU :)

remote_file 'jdk-8u131-linux-x64.tar.gz' do
 source 'http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz'
 headers ({ "Cookie" => "oraclelicense=a" })
 action :create
end
