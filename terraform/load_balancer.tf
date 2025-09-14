# Target Group для веб-серверов
resource "yandex_alb_target_group" "web" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web2.network_interface.0.ip_address
  }
}

# Backend Group
resource "yandex_alb_backend_group" "web" {
  name = "web-backend-group"

  http_backend {
    name             = "web-http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 5
      unhealthy_threshold  = 3
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

# HTTP Router
resource "yandex_alb_http_router" "web" {
  name = "web-http-router"
}

# Virtual Host
resource "yandex_alb_virtual_host" "web" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web.id

  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
        timeout          = "60s"
      }
    }
  }
}

# Application Load Balancer
resource "yandex_alb_load_balancer" "web" {
  name        = "web-load-balancer"
  network_id  = yandex_vpc_network.main.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web.id
      }
    }
  }
}