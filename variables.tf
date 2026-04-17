variable "tenancy_ocid" { type = string }
variable "user_ocid" { type = string }
variable "fingerprint" { type = string }
variable "private_key_path" { type = string }
variable "region" { type = string }
variable "compartment_name" {
  type    = string
  default = "delta-copy-test"
}
variable "compartment_description" {
  type    = string
  default = "Compartment for Delta Incremental Copy pipeline"
}
variable "dataflow_display_name" {
  type    = string
  default = "DeltaIncrementalCopy"
}
variable "script_file_uri" { type = string }
variable "logs_bucket_uri" { type = string }
variable "warehouse_bucket_uri" { type = string }
variable "spark_version" {
  type    = string
  default = "3.5.0"
}
variable "driver_shape" {
  type    = string
  default = "VM.Standard.E4.Flex"
}
variable "driver_shape_ocpus" {
  type    = number
  default = 1
}
variable "driver_shape_memory_gb" {
  type    = number
  default = 16
}
variable "executor_shape" {
  type    = string
  default = "VM.Standard.E4.Flex"
}
variable "executor_shape_ocpus" {
  type    = number
  default = 1
}
variable "executor_shape_memory_gb" {
  type    = number
  default = 16
}
variable "num_executors" {
  type    = number
  default = 1
}
variable "source_path" { type = string }
variable "dest_path" { type = string }
variable "time_column" {
  type    = string
  default = "load_timestamp"
}
variable "tenancy_column" {
  type    = string
  default = "tenancy_id"
}
variable "lookback_days" {
  type    = number
  default = null
}
variable "di_workspace_name" {
  type    = string
  default = "delta-copy-workspace"
}
variable "di_application_name" {
  type    = string
  default = "DeltaCopyApp"
}
variable "di_application_identifier" {
  type    = string
  default = "DELTA_COPY_APP"
}
variable "di_task_name" {
  type    = string
  default = "DeltaCopyDailyRun"
}
variable "di_task_identifier" {
  type    = string
  default = "DELTA_COPY_DAILY_RUN"
}
variable "di_schedule_name" {
  type    = string
  default = "DeltaCopyDailySchedule"
}
variable "di_schedule_identifier" {
  type    = string
  default = "DELTA_COPY_DAILY_SCHEDULE"
}
variable "schedule_timezone" {
  type    = string
  default = "UTC"
}
variable "schedule_hour" {
  type    = number
  default = 2
}
variable "schedule_minute" {
  type    = number
  default = 0
}
variable "di_project_name" {
  type    = string
  default = "DeltaCopyProject"
}
variable "di_project_identifier" {
  type    = string
  default = "DELTA_COPY_PROJECT"
}
variable "di_task_schedule_name" {
  type    = string
  default = "DeltaCopyTaskSchedule"
}
variable "di_task_schedule_identifier" {
  type    = string
  default = "DELTA_COPY_TASK_SCHEDULE"
}
