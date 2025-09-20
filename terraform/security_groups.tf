# Sec Group для Bastion
resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  description = "Security group for bastion host"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "SSH from anywhere"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group для Web серверов
resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for web servers"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "HTTP from public subnet (for ALB)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["192.168.10.0/24"]
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description       = "Zabbix agent from zabbix server"
    protocol          = "TCP"
    port              = 10050
    security_group_id = yandex_vpc_security_group.zabbix_sg.id
  }

  ingress {
    description    = "ICMP for monitoring"
    protocol       = "ICMP"
    v4_cidr_blocks = ["192.168.10.0/24"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group для Zabbix Server
resource "yandex_vpc_security_group" "zabbix_sg" {
  name        = "zabbix-security-group"
  description = "Security group for zabbix server"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "HTTP from anywhere"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS from anywhere"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Zabbix server port"
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description    = "SSH from anywhere (for ansible)"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "ICMP for monitoring"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group для Elasticsearch
resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name        = "elasticsearch-security-group"
  description = "Security group for elasticsearch"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description       = "Elasticsearch from kibana"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.kibana_sg.id
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description       = "Zabbix agent from zabbix server"
    protocol          = "TCP"
    port              = 10050
    security_group_id = yandex_vpc_security_group.zabbix_sg.id
  }

  ingress {
    description    = "ICMP for monitoring"
    protocol       = "ICMP"
    v4_cidr_blocks = ["192.168.10.0/24"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group для Kibana
resource "yandex_vpc_security_group" "kibana_sg" {
  name        = "kibana-security-group"
  description = "Security group for kibana"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "Kibana web interface from anywhere"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  ingress {
    description    = "SSH from anywhere (for ansible)"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Zabbix agent from zabbix server"
    protocol          = "TCP"
    port              = 10050
    security_group_id = yandex_vpc_security_group.zabbix_sg.id
  }

  ingress {
    description    = "ICMP for monitoring"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group для Application Load Balancer
resource "yandex_vpc_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for application load balancer"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "HTTP from anywhere"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS from anywhere"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}