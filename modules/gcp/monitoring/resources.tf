resource "google_monitoring_uptime_check_config" "host" {
  for_each = toset(local.hosts)

  display_name = each.key
  timeout = "60s"
  period = "60s"

  http_check {
    path = "/"
    port = "443"
    request_method = "GET"
    use_ssl = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = local.project
      host = each.key
    }
  }
}

resource "google_monitoring_alert_policy" "uptime-check" {
  for_each = toset(local.hosts)

  project = local.project
  display_name = "${each.key} uptime failure"
  notification_channels = [data.google_monitoring_notification_channel.slack.name]
  combiner = "OR"
  conditions {
    display_name = "Failure of uptime check on ${each.key}"
    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.host[each.key].uptime_check_id}\" AND resource.type=\"uptime_url\""
      duration  = "60s"
      threshold_value = 1
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields = [
          "resource.label.*"
        ]
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }

      trigger {
        count = 1
        percent = 0
      }
    }
  }

  documentation {
    content   = "https://${each.key}"
    mime_type = "text/markdown"
  }

  user_labels = {
    env = var.env
    terraform = true
  }
}
