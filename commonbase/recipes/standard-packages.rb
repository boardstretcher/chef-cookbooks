# 
# Packages that should be installed everywhere
#

if platform?('centos')
	case node.environment
	when 'at'
		package 'screen' do
			action :install
		end
		package 'vim' do
			action :install
		end
	end # case
end # endif
