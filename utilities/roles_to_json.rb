require 'chef'

# Update path to reflect    where your chef style roles are stored
ROLE_DIR = "/root/tmp/roles"

Dir.glob(File.join(ROLE_DIR, '*.rb')) do |rb_file|
  role = Chef::Role.new
  role.from_file(rb_file)
  json_file = rb_file.sub(/\.rb$/,'.json') 
  File.open(json_file, 'w'){|f| f.write(JSON.pretty_generate(role))}
end
