# Bastion host
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Web Server 1
resource "yandex_compute_instance" "web1" {
  name        = "web1"
  hostname    = "web1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Web Server 2
resource "yandex_compute_instance" "web2" {
  name        = "web2"
  hostname    = "web2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_b.id
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Zabbix Server
resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.zabbix_sg.id]
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Elasticsearch Server
resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_a.id
    security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id]
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}

# Kibana Server
resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.debian_image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana_sg.id]
  }

  metadata = {
    ssh-keys = "debian:${var.ssh_public_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}