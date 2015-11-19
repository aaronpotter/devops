# Snippets for MySql

Pipe for dumping data into a RDS server

    mysqldump  --host=<INTERNAL_SERVER_URI> --databases <DBNAME> --compress --order-by-primary -u<USERNAME> -p<PASSWORD> | mysql --host=<RDS_SERVER_URI> -u<USERNAME> -p<PASSWORD> <DBNAME>
