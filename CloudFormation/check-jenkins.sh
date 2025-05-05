#!/bin/bash

echo "============= CHECKING JENKINS STATUS ============="
# Check if Jenkins is running
systemctl status jenkins
JENKINS_STATUS=$?

# If not running, try to start it
if [ $JENKINS_STATUS -ne 0 ]; then
  echo "Jenkins is not running. Attempting to start..."
  systemctl start jenkins
  sleep 5
  systemctl status jenkins
  JENKINS_STATUS=$?
fi

# Check Java installation
echo "============= CHECKING JAVA INSTALLATION ============="
java -version
which java

# Check Jenkins process
echo "============= CHECKING JENKINS PROCESS ============="
ps aux | grep jenkins

# Check network connectivity
echo "============= CHECKING NETWORK ============="
echo "Checking localhost port 8080:"
curl -v localhost:8080 2>&1 | grep "HTTP"

# Check firewall
echo "============= CHECKING FIREWALL RULES ============="
iptables -L | grep 8080

# Check Jenkins logs
echo "============= CHECKING JENKINS LOGS ============="
if [ -f /var/log/jenkins/jenkins.log ]; then
  tail -50 /var/log/jenkins/jenkins.log
else
  echo "Jenkins log file not found at expected location"
  find /var/log -name "jenkins*" 2>/dev/null
fi

# Check if Jenkins service is enabled
echo "============= CHECKING IF JENKINS IS ENABLED ============="
systemctl is-enabled jenkins

# Check system resources
echo "============= CHECKING SYSTEM RESOURCES ============="
free -m
df -h

echo "============= CHECKING JENKINS INITIAL PASSWORD ============="
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  echo "Jenkins initial admin password:"
  cat /var/lib/jenkins/secrets/initialAdminPassword
else
  echo "Initial admin password file not found"
fi

echo "============= TROUBLESHOOTING COMPLETE ============="