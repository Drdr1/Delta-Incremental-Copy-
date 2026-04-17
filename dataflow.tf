# ------------------------------------------------------------------------------
# Data Flow Application
# ------------------------------------------------------------------------------
# Registers the PySpark script as a Data Flow application with Delta Lake
# Spark config and configurable driver/executor shapes.

locals {
  # Build the positional arguments list for the script:
  #   delta_incremental_copy.py <source_path> <dest_path> <time_column> <tenancy_column> [--lookback-days N]
  script_args_base = [
    var.source_path,
    var.dest_path,
    var.time_column,
    var.tenancy_column,
  ]

  script_args_lookback = var.lookback_days != null ? [
    "--lookback-days", tostring(var.lookback_days),
  ] : []

  script_arguments = concat(local.script_args_base, local.script_args_lookback)
}

resource "oci_dataflow_application" "delta_copy" {
  compartment_id = oci_identity_compartment.this.id
  display_name   = var.dataflow_display_name
  language       = "PYTHON"
  spark_version  = var.spark_version

  file_uri       = var.script_file_uri
  logs_bucket_uri      = var.logs_bucket_uri
  warehouse_bucket_uri = var.warehouse_bucket_uri

  # --- Driver shape ---
  driver_shape = var.driver_shape
  driver_shape_config {
    ocpus         = var.driver_shape_ocpus
    memory_in_gbs = var.driver_shape_memory_gb
  }

  # --- Executor shape ---
  executor_shape = var.executor_shape
  executor_shape_config {
    ocpus         = var.executor_shape_ocpus
    memory_in_gbs = var.executor_shape_memory_gb
  }
  num_executors = var.num_executors

  # --- Script arguments ---
  arguments = local.script_arguments

  # --- Spark configuration (Delta Lake + multi-region) ---
  configuration = {
    "spark.oracle.deltalake.version"                 = "3.1.0"
    "spark.hadoop.fs.oci.client.multiregion.enabled"  = "true"
  }
}
