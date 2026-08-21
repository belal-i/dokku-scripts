post_deploy() {
  systemctl restart fail2ban.service
}
