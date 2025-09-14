# Snapshot schedule для всех ВМ
resource "yandex_compute_snapshot_schedule" "daily_backup" {
  name           = "daily-snapshots-dip"
  retention_period = "168h" # 7 дней

  schedule_policy {
    expression = "0 2 * * *" # Ежедневно в 2:00
  }

  snapshot_count = 7

  disk_ids = [
    yandex_compute_instance.bastion.boot_disk.0.disk_id,
    yandex_compute_instance.web1.boot_disk.0.disk_id,
    yandex_compute_instance.web2.boot_disk.0.disk_id,
    yandex_compute_instance.zabbix.boot_disk.0.disk_id,
    yandex_compute_instance.elasticsearch.boot_disk.0.disk_id,
    yandex_compute_instance.kibana.boot_disk.0.disk_id
  ]
}