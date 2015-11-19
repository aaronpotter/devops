execute "Changing short_open_tag = Off to On" do
  command 'sed -i \'s/short_open_tag = Off/short_open_tag = On/g\' /etc/php5/apache2/php.ini'
end

execute "Adding include_path" do
  command 'echo \'include_path = ".:/usr/share/php:/usr/share/php/libzend-framework-php"\' >> /etc/php5/apache2/php.ini '
end

execute "extension=igbinary.so" do
  command 'echo "extension=igbinary.so" >> /etc/php5/apache2/php.ini '
end

execute "extension=memcache.so" do
  command 'echo "extension=memcache.so" >> /etc/php5/apache2/php.ini '
end

#Restart Apache:
service "apache2" do
        action [:restart]
end
