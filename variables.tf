# ------------------------------------------------------------------------------
# OCI Provider Authentication
# ------------------------------------------------------------------------------
variable "tenancy_ocid" {
  description = "OCID of the OCI tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the OCI user for API authentication"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API signing key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the OCI API private key PEM file"
  type        = string
}

variable "region" {
  description = "OCI region (e.g. us-ashburn-1, eu-frankfurt-1)"
  type        = string
}

# ------------------------------------------------------------------------------
# Compartment (must already exist)
# ------------------------------------------------------------------------------
variable "compartment_id" {
  description = "OCID of an existing compartment for all resources"
  type        = string
}

# ------------------------------------------------------------------------------
# Data Flow — Application
# ------------------------------------------------------------------------------
variable "dataflow_display_name" {
  description = "Display name for the Data Flow application"
  type        = string
  default     = "DeltaIncrementalCopy"
}

variable "script_file_uri" {
  description = "OCI Object Storage URI of the PySpark script (e.g. oci://bucket@namespace/Delta_Incremental_Copy.py)"
  type        = string
}

variable "logs_bucket_uri" {
  description = "OCI Object Storage URI for Data Flow logs (e.g. oci://logs-bucket@namespace/)"
  type        = string
}

variable "spark_version" {
  description = "Apache Spark version for the Data Flow application"
  type        = string
  default     = "3.5.0"
}

# ------------------------------------------------------------------------------
# Data Flow — Compute Shape (Driver & Executors)
# ------------------------------------------------------------------------------
variable "driver_shape" {
  description = "Compute shape for the Spark driver"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "driver_shape_ocpus" {
  description = "Number of OCPUs for the Spark driver (flex shapes only)"
  type        = number
  default     = 1
}

variable "driver_shape_memory_gb" {
  description = "Memory in GB for the Spark driver (flex shapes only)"
  type        = number
  default     = 16
}

variable "executor_shape" {
  description = "Compute shape for Spark executors"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "executor_shape_ocpus" {
  description = "Number of OCPUs per Spark executor (flex shapes only)"
  type        = number
  default     = 1
}

variable "executor_shape_memory_gb" {
  description = "Memory in GB per Spark executor (flex shapes only)"
  type        = number
  default     = 16
}

variable "num_executors" {
  description = "Number of Spark executor instances"
  type        = number
  default     = 1
}

# ------------------------------------------------------------------------------
# Data Flow — Script Arguments
# ------------------------------------------------------------------------------
variable "source_path" {
  description = "OCI path to source Delta table (e.g. oci://source-bucket@namespace/path/to/delta_table)"
  type        = string
}

variable "dest_path" {
  description = "OCI path to destination Delta table (e.g. oci://dest-bucket@namespace/path/to/delta_table)"
  type        = string
}

variable "time_column" {
  description = "Name of the timestamp/date column used for incremental reads"
  type        = string
  default     = "load_timestamp"
}

variable "tenancy_column" {
  description = "Name of the column used to filter rows by tenancy"
  type        = string
  default     = "tenancy_id"
}

variable "lookback_days" {
  description = "Initial-import lookback window in days (null = full import). Passed as --lookback-days to the script."
  type        = number
  default     = null
}

# ------------------------------------------------------------------------------
# Data Integration — Workspace & Application
# ------------------------------------------------------------------------------
variable "di_workspace_name" {
  description = "Display name for the Data Integration workspace"
  type        = string
  default     = "delta-copy-workspace"
}

variable "di_application_name" {
  description = "Display name for the Data Integration application"
  type        = string
  default     = "DeltaCopyApp"
}

variable "di_application_identifier" {
  description = "Identifier (must be uppercase, no spaces) for the DI application"
  type        = string
  default     = "DELTA_COPY_APP"
}

# ------------------------------------------------------------------------------
# Data Integration — Project
# ------------------------------------------------------------------------------
variable "di_project_name" {
  description = "Display name for the DI project"
  type        = string
  default     = "DeltaCopyProject"
}

variable "di_project_identifier" {
  description = "Identifier for the DI project"
  type        = string
  default     = "DELTA_COPY_PROJECT"
}

# ------------------------------------------------------------------------------
# Data Integration — Task
# ------------------------------------------------------------------------------
variable "di_task_name" {
  description = "Display name for the Data Flow task"
  type        = string
  default     = "DeltaCopyDailyRun"
}

variable "di_task_identifier" {
  description = "Identifier (uppercase, no spaces) for the task"
  type        = string
  default     = "DELTA_COPY_DAILY_RUN"
}

# ------------------------------------------------------------------------------
# Data Integration — Schedule
# ------------------------------------------------------------------------------
variable "di_schedule_name" {
  description = "Display name for the daily schedule"
  type        = string
  default     = "DeltaCopyDailySchedule"
}

variable "di_schedule_identifier" {
  description = "Identifier (uppercase, no spaces) for the schedule"
  type        = string
  default     = "DELTA_COPY_DAILY_SCHEDULE"
}

variable "schedule_timezone" {
  description = "IANA timezone for the schedule (e.g. UTC, Asia/Riyadh)"
  type        = string
  default     = "UTC"
}

variable "schedule_hour" {
  description = "Hour of day (0-23) to run the daily job"
  type        = number
  default     = 6
}

variable "schedule_minute" {
  description = "Minute of hour (0-59) to run the daily job"
  type        = number
  default     = 0
}

# ------------------------------------------------------------------------------
# Data Integration — Task Schedule
# ------------------------------------------------------------------------------
variable "di_task_schedule_name" {
  description = "Display name for the task schedule"
  type        = string
  default     = "DeltaCopyTaskSchedule"
}

variable "di_task_schedule_identifier" {
  description = "Identifier for the task schedule"
  type        = string
  default     = "DELTA_COPY_TASK_SCHEDULE"
}
