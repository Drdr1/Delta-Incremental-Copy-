# ------------------------------------------------------------------------------
# Data Flow Application
# ------------------------------------------------------------------------------
locals {
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
  compartment_id = var.compartment_id
  display_name   = var.dataflow_display_name
  language       = "PYTHON"
  spark_version  = var.spark_version

  file_uri        = var.script_file_uri
  logs_bucket_uri = var.logs_bucket_uri

  driver_shape = var.driver_shape
  driver_shape_config {
    ocpus         = var.driver_shape_ocpus
    memory_in_gbs = var.driver_shape_memory_gb
  }

  executor_shape = var.executor_shape
  executor_shape_config {
    ocpus         = var.executor_shape_ocpus
    memory_in_gbs = var.executor_shape_memory_gb
  }
  num_executors = var.num_executors

  arguments = local.script_arguments

  configuration = {
    "spark.oracle.deltalake.version"                = "3.1.0"
    "spark.hadoop.fs.oci.client.multiregion.enabled" = "true"
  }
}
