resource "google_service_account" "sa" {
  for_each = toset(var.clients)

  account_id = "${var.namespace}-${each.key}"
  display_name = title("${var.namespace} ${each.key}")
}

resource "google_project_iam_member" "member_roles" {
  for_each = toset(var.clients)

  role = var.iam_role_name
  member = "serviceAccount:${google_service_account.sa[each.key].email}"

    dynamic "condition" {
      for_each = var.iam_role_condition == "" ? [] : [1]

      content {
        title = title("${var.namespace} ${each.key}")
        expression = replace(var.iam_role_condition, "$CLIENT$", each.key)
      }
    }
}
