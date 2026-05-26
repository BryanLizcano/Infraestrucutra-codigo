#!/bin/bash
# ==============================================================================
# user_data.sh — Inicialización Bootstrap para el ASG
# Distribución: Amazon Linux 2023 (gestor de paquetes: dnf)
# ==============================================================================

dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lab 6 - Escalado automático y balanceo de carga</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .card { background: white; border-radius: 12px; padding: 40px 60px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center; max-width: 500px; }
    h1 { color: #232f3e; }
    .badge { display: inline-block; background-color: #ff9900; color: white; padding: 8px 20px; border-radius: 20px; font-size: 1.1em; margin-top: 10px; }
    .info { color: #555; margin-top: 20px; font-size: 0.9em; }
  </style>
</head>
<body>
  <div class="card">
    <h1>&#9889; Lab 6</h1>
    <p><strong>Escalado automático y balanceo de carga</strong></p>
    <p>Esta respuesta fue servida por:</p>
    <div class="badge">Zona de disponibilidad: ${AZ}</div>
    <p class="info">Instance ID: ${INSTANCE_ID}</p>
    <p class="info">Diseño y Gestión de Infraestructura Tecnológica</p>
  </div>
</body>
</html>
EOF

chmod 644 /var/www/html/index.html