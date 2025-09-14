[bastion]
bastion.ru-central1.internal ansible_host=${bastion_public_ip}

[web_servers]
web1.ru-central1.internal ansible_host=${web1_private_ip}
web2.ru-central1.internal ansible_host=${web2_private_ip}

[zabbix_server]
zabbix.ru-central1.internal ansible_host=${zabbix_public_ip}

zabbix.ru-central1.internal ansible_python_interpreter=/usr/bin/python3

[elastic_server]
elasticsearch.ru-central1.internal ansible_host=${elasticsearch_private_ip}

[kibana_server]
kibana.ru-central1.internal ansible_host=${kibana_public_ip}

# Только для внутренних хостов используем bastion
[internal:children]
web_servers
elastic_server

[internal:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -W %h:%p -q debian@${bastion_public_ip}"'

# Для публичных хостов прямое подключение  
[public:children]
bastion
zabbix_server
kibana_server

[public:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

[all:vars]
ansible_user=debian
ansible_ssh_private_key_file=/home/ras/.ssh/id_ed25519
ansible_python_interpreter=/usr/bin/python3