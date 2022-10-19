#Verificacion de sistema
cat /etc/system-release
cat /proc/cpuinfo

#Instalacion de paquetes: PHP, Apache
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd

#Setup apache
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd

#Instalacion de script PHP
sudo bash
cat <<'EOF' > /var/www/html/index.php
<html>
<body>
<?php
$user = 'admin';
$pass = 'main-rds-password';
$endp = 'database-rds-lamp.cswn6naz8dnp.us-east-2.rds.amazonaws.com';

print 'Hola! Soy <b>' . gethostname() . '</b>';
$link = new mysqli($endp, $user, $pass);
if ($link->connect_errno){
    die('Could no connect: ' . $link->connect_error);
}

if (!($result = $link->query("SELECT now() AS tmm"))) {
    die ('Error Message: ' . $link->error);
}

while($obj = $result->fetch_object()) {
    echo 'En este momento son las <b>' . $obj->tmm . '</b>';
}
$link->close();
?>
</body>
</html>
EOF
exit

#Check instalation
wget -O /dev/stdout -o /dev/null http://localhost:80/index.php