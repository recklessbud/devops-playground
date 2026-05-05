#!/bin/bash
# User data script for EC2 instances in Auto Scaling group

# Update system packages
yum update -y

# Install and configure Apache web server
yum install -y httpd

# Create a simple web page with instance information
# FIX: ${environment} is a templatefile() variable; bash $(...) subshells are written
# as dollar-sign literals here so templatefile() does not try to interpolate them.
cat > /var/www/html/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Auto Scaling Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background-color: #232F3E; color: white; padding: 20px; border-radius: 5px; }
        .content { margin: 20px 0; }
        .info-box { background-color: #E7F3FF; padding: 15px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🚀 Auto Scaling Demo Server</h1>
        <p>Environment: ${environment}</p>
    </div>
    <div class="content">
        <div class="info-box">
            <h3>Instance Information</h3>
            <p><strong>Hostname:</strong> HOSTNAME_PLACEHOLDER</p>
            <p><strong>Instance ID:</strong> INSTANCE_ID_PLACEHOLDER</p>
            <p><strong>Availability Zone:</strong> AZ_PLACEHOLDER</p>
            <p><strong>Instance Type:</strong> TYPE_PLACEHOLDER</p>
            <p><strong>Launch Time:</strong> TIME_PLACEHOLDER</p>
        </div>
        <div class="info-box">
            <h3>Server Status</h3>
            <p>✅ Apache HTTP Server is running</p>
            <p>✅ Auto Scaling Group is managing this instance</p>
            <p>✅ CloudWatch monitoring is enabled</p>
        </div>
    </div>
</body>
</html>
HTML

# Replace placeholders with live instance metadata at boot time
sed -i "s|HOSTNAME_PLACEHOLDER|$(hostname -f)|g" /var/www/html/index.html
sed -i "s|INSTANCE_ID_PLACEHOLDER|$(curl -s http://169.254.169.254/latest/meta-data/instance-id)|g" /var/www/html/index.html
sed -i "s|AZ_PLACEHOLDER|$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)|g" /var/www/html/index.html
sed -i "s|TYPE_PLACEHOLDER|$(curl -s http://169.254.169.254/latest/meta-data/instance-type)|g" /var/www/html/index.html
sed -i "s|TIME_PLACEHOLDER|$(date)|g" /var/www/html/index.html

# Start and enable Apache service
systemctl start httpd
systemctl enable httpd

# Configure CloudWatch agent if available
if command -v amazon-cloudwatch-agent-ctl &> /dev/null; then
    echo "CloudWatch agent is available for configuration" 
fi

echo "$(date): User data script completed successfully" >> /var/log/user-data.log
