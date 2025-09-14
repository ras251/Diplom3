resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    bastion_public_ip        = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    web1_private_ip          = yandex_compute_instance.web1.network_interface.0.ip_address
    web2_private_ip          = yandex_compute_instance.web2.network_interface.0.ip_address
    zabbix_public_ip         = yandex_compute_instance.zabbix.network_interface.0.nat_ip_address
    elasticsearch_private_ip = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
    kibana_public_ip         = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
  })
  filename = "../ansible/inventory.ini"
}