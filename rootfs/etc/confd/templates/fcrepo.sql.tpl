CREATE DATABASE IF NOT EXISTS {{getv "/fcrepo/db"}} CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '{{getv "/fcrepo/db/user"}}'@'%' IDENTIFIED BY '{{getv "/fcrepo/db/password"}}';
GRANT ALL PRIVILEGES ON {{getv "/fcrepo/db"}}.* to '{{getv "/fcrepo/db/user"}}'@'%';
FLUSH PRIVILEGES;
