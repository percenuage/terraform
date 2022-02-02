resource "google_project_iam_custom_role" "custom_role" {
  for_each = var.custom_roles

  role_id = each.key
  title = title(replace(each.key, "_", " "))
  permissions = each.value
}

resource "google_service_account" "sa" {
  depends_on = [google_project_iam_custom_role.custom_role]
  for_each = var.service_accounts

  account_id = each.key
  display_name = title(replace(each.key, "-", " "))
}

resource "google_project_iam_member" "member_roles" {
  count = length(local.member_role_pairs)

  project = var.project
  role = local.member_role_pairs[count.index].role
  member = local.member_role_pairs[count.index].member
}
