package ['libapache2-mod-php5', 'php5-memcached', 'php5-mysql', 'php5-gd', 'php5-ldap', 'php5-mcrypt', 'zend-framework', 'php5-curl', 'php5-xsl'] do 
	action :install
end	

execute "install pear XML_RPC2" do
  command 'pear install XML_RPC2'
end

execute "install pear XML_RPC" do
  command 'pear install XML_RPC'
end

package ['libpcre3-dev', 'pkg-config'] do 
	action :install
end	

execute "install pecl igbinary" do
  command 'pecl install igbinary'
end

execute "install pecl memcache" do
  command 'yes | pecl install memcache'
end

package 'libmemcached-dev' do
        action :remove
end

package ['libsasl2-dev', 'build-essential'] do
        action :install
end

execute "download libmemcahed" do
  cwd "/tmp"
  command 'wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz'
end

execute "tar libmemcahed" do
  cwd "/tmp"
  command 'tar xzf libmemcached-1.0.18.tar.gz'
end

execute "configure libmemcached" do
  cwd "/tmp/libmemcached-1.0.18"
  command './configure --enable-sasl'
end

execute "make libmemcached" do
  cwd "/tmp/libmemcached-1.0.18"
  command 'make'
end

execute "make install  libmemcached" do
  cwd "/tmp/libmemcached-1.0.18"
  command 'make install'
end
