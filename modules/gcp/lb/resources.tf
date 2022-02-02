resource "google_compute_backend_service" "default" {
  for_each = toset(var.subdomains)

  name = "${var.namespace}-${var.env}-${each.key}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  locality_lb_policy = "ROUND_ROBIN"
  port_name = "http"
  protocol = "HTTP"
  connection_draining_timeout_sec = 0
  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg[each.key].id
  }
  log_config {
    enable = false
  }
  enable_cdn = false
  health_checks = null
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  for_each = toset(var.subdomains)

  name = "${var.namespace}-${var.env}-${each.key}"
  region = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = "${var.namespace}-${var.env}-${each.key}"
  }
}

resource "google_compute_global_address" "default" {
  name = "${var.namespace}-${var.env}-ip"
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "${var.env}-${replace(var.domain, ".", "-")}"

  managed {
    domains = local.hosts
  }
}

resource "google_compute_url_map" "default" {
  name = "${var.namespace}-${var.env}"
  default_service = google_compute_backend_service.default[var.subdomains[0]].id

  dynamic "host_rule" {
    for_each = local.hosts
    content {
      hosts = [host_rule.value]
      path_matcher = "path-matcher-${host_rule.key}"
    }
  }

  dynamic "path_matcher" {
    for_each = var.subdomains
    content {
      name = "path-matcher-${path_matcher.key}"
      default_service = google_compute_backend_service.default[path_matcher.value].id
    }
  }
}

resource "google_compute_url_map" "redirect" {
  name = "${var.namespace}-${var.env}-redirect"
  default_url_redirect {
    https_redirect = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query = false
  }
}

resource "google_compute_target_https_proxy" "default" {
  name = "${var.namespace}-${var.env}-target-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
}

resource "google_compute_target_http_proxy" "redirect" {
  name = "${var.namespace}-${var.env}-redirect-target-proxy"
  url_map = google_compute_url_map.redirect.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name = "${var.namespace}-${var.env}"
  target = google_compute_target_https_proxy.default.id
  ip_address = google_compute_global_address.default.id
  port_range = 443
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_global_forwarding_rule" "redirect" {
  name = "${var.namespace}-${var.env}-redirect"
  target = google_compute_target_http_proxy.redirect.id
  ip_address = google_compute_global_address.default.id
  port_range = 80
  load_balancing_scheme = "EXTERNAL"
}
