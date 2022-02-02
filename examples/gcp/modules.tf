module "vpc" {
  source = "../../modules/gcp/vpc"

  env = var.env
  namespace = var.namespace
  region = var.region
  zone = var.zone
  subnetwork_cidr = "10.0.0.0/16"
}

module "gke" {
  source = "../../modules/gcp/gke"

  env = var.env
  namespace = var.namespace
  network_name = module.vpc.google_compute_network_name
  subnetwork_name = module.vpc.google_compute_subnetwork_name
  location = var.region
  machine_type = "n2d-standard-8"
  min_node_count = 1
  max_node_count = 10
  disk_size_gb = 50
}

module "nat" {
  source = "../../modules/gcp/nat"

  env = var.env
  namespace = var.namespace
  network_name = module.vpc.google_compute_network_name
  subnetwork_name = module.vpc.google_compute_subnetwork_name
}

module "iam" {
  source = "../../modules/gcp/iam"

  env = var.env
  namespace = var.namespace
  custom_roles = {
    percenuage = [
      "storage.buckets.getIamPolicy",
      "storage.buckets.get",
      "storage.buckets.list",
      "storage.objects.get",
      "storage.objects.list",
      "storage.objects.create",
      "storage.objects.delete",
      "storage.objects.update",
      "cloudsql.instances.get",
      "cloudsql.instances.connect",
    ]
  }
  service_accounts = {
    bitbucket = [
      "roles/container.developer",
      "roles/storage.admin",
    ]
  }
}

module "super_client" {
  source = "../../modules/gcp/super_client"
  depends_on = [module.iam]

  env = var.env
  namespace = var.namespace
  location = var.region

  clients = ["mars", "jupiter", "titan"]

  iam_role_name = "projects/${local.project}/roles/percenuage"
    iam_role_condition = "resource.name.startsWith(\"projects/_/buckets/${local.project}-$CLIENT$\") || resource.service == \"sqladmin.googleapis.com\""

  bucket_names = [
    "backups", "media", "exports", "assets", "chili-assets", "slider-assets", "invoices", "pdf", "misc"
  ]
  bucket_viewers = {
    media = "allUsers,allAuthenticatedUsers"
    assets = "allUsers,allAuthenticatedUsers"
    chili-assets = "allUsers,allAuthenticatedUsers"
    slider-assets = "allUsers,allAuthenticatedUsers"
    invoices = "allUsers,allAuthenticatedUsers"
    exports = "allUsers,allAuthenticatedUsers"
  }
  bucket_lifecycle = {
    exports = 1
    backups = 14
  }
}

module "gcs" {
  source = "../../modules/gcp/gcs"

  env = var.env
  namespace = var.namespace
  location = var.region
  bucket_names = ["random"]
  bucket_viewers = {
    random = "allUsers,allAuthenticatedUsers"
  }
}

module "memorystore" {
  source = "../../modules/gcp/memorystore"

  env = var.env
  namespace = var.namespace
  region = var.region
  zone = var.zone
  network = module.vpc.google_compute_network_id
}

module "monitoring" {
  source = "../../modules/gcp/monitoring"

  env = var.env
  namespace = var.namespace
  domain = "percenuage.fr"
  subdomains = ["app"]
  clients = ["mars"]
  client_subdomains = []
}

module "sql" {
  source = "../../modules/gcp/sql"

  env = var.env
  namespace = var.namespace
  region = var.region
  database_version = "POSTGRES_13"
  enable_backup = true
  databases = ["${var.namespace}-${var.env}"]
  users = ["ops"]
}

module "run_percenuage_app" {
  source  = "garbetjie/cloud-run/google"
  version = "2.1.1"

  depends_on = [module.iam]

  name = "${var.namespace}-${var.env}-app"
  image = "eu.gcr.io/${local.project}/app:2022-02-01T15-25_76f97019"
  location = var.region
  allow_public_access = false
  cpus = 1
  memory = 128
  port = 80
  env = [
    { key = "REACT_APP_BACKEND_URL", value = "api.dev.percenuage.fr" },
    { key = "REACT_APP_BACKEND_PORT", value = "8080" },
  ]
  ingress = "internal-and-cloud-load-balancing"
  min_instances = 0
  max_instances = 100
  labels = {
    env = var.env
    name = "app"
    terraform = true
  }
  revision = null
  service_account_email = "percenuage@${local.project}.iam.gserviceaccount.com"
  timeout = 60
}

module "run_percenuage_api" {
  source  = "garbetjie/cloud-run/google"
  version = "2.1.1"

  depends_on = [module.iam]

  name = "${var.namespace}-${var.env}-api"
  image = "eu.gcr.io/${local.project}/api:2022-01-26T02-25_187d278e"
  location = var.region
  allow_public_access = false
  cpus = 1
  memory = 512
  port = 3000
  env = [
    { key = "CLOUD_SQL_CONNECTION_NAME", value = "${local.project}:${var.region}:${var.namespace}-${var.env}-sql" },
    { key = "POSTGRES_USER", value = "ops" },
    { key = "POSTGRES_DBNAME", value = "${var.namespace}-${var.env}" },
    { key = "POSTGRES_PASSWORD", secret = "${var.namespace}-${var.env}-sql-ops-secret" },
    { key = "ENV", value = "prod" },
  ]
  ingress = "internal-and-cloud-load-balancing"
  min_instances = 0
  max_instances = 100
  cloudsql_connections = ["${local.project}:${var.region}:${var.namespace}-${var.env}-sql"]
  labels = {
    env = var.env
    name = "api"
    terraform = true
  }
  revision = null
  service_account_email = "${var.namespace}@${local.project}.iam.gserviceaccount.com"
  timeout = 60
}

module "lb" {
  source = "../../modules/gcp/lb"
  depends_on = [
    module.run_percenuage_app,
    module.run_percenuage_api,
  ]

  env = var.env
  namespace = var.namespace
  project = local.project
  region = var.region
  domain = "percenuage.net"
  subdomains = ["app", "api"]
}
