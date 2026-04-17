# Delta Incremental Copy — OCI Terraform Deployment

Automates the deployment of an **OCI Data Flow** application with a **Data Integration** daily schedule to run `Delta_Incremental_Copy.py`. Everything is created via Terraform — no manual Console steps required.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│  OCI Data Integration                                       │
│                                                             │
│  Workspace ─► Application ─► Task Schedule (daily 02:00)    │
│                                    │                        │
│                                    ▼                        │
│                           OCI Data Flow Task                │
│                                    │                        │
└────────────────────────────────────┼────────────────────────┘
                                     │ triggers
                                     ▼
┌─────────────────────────────────────────────────────────────┐
│  OCI Data Flow Application                                  │
│                                                             │
│  Delta_Incremental_Copy.py                                  │
│  Spark Config:                                              │
│    spark.oracle.deltalake.version = 3.1.0                   │
│    spark.hadoop.fs.oci.client.multiregion.enabled = true    │
│                                                             │
│  Arguments:                                                 │
│    <source_path> <dest_path> <time_col> <tenancy_col>       │
│    [--lookback-days N]                                      │
└─────────────────────────────────────────────────────────────┘
         │                                    │
         ▼                                    ▼
   Source Bucket                        Dest Bucket
   (Delta Table)                        (Delta Table)
```

## What Terraform Creates (8 Resources)

| Resource                              | File                   |
|---------------------------------------|------------------------|
| Compartment                           | `compartment.tf`       |
| Data Flow application                 | `dataflow.tf`          |
| Data Integration workspace            | `dataintegration.tf`   |
| Data Integration application          | `dataintegration.tf`   |
| OCI Data Flow task                    | `dataintegration.tf`   |
| Daily schedule                        | `dataintegration.tf`   |
| Task schedule (binds task to schedule)| `dataintegration.tf`   |

---

## Prerequisites (Manual — Created Before Terraform)

### 1. OCI API Key

Generate an API key pair in the OCI Console:
- Profile icon → My profile → API keys → Add API key
- Download the private key to `~/.oci/oci_api_key.pem`
- Save the Configuration file preview values for `terraform.tfvars`

### 2. OCI Object Storage Buckets

Create buckets (via Console or CLI):

```bash
NS=$(oci os ns get --query 'data' --raw-output)
TENANCY="<your-tenancy-ocid>"

for BUCKET in delta-copy-scripts delta-copy-source delta-copy-dest dataflow-logs dataflow-warehouse; do
  oci os bucket create --compartment-id $TENANCY --name $BUCKET
done
```

### 3. Upload the Script

```bash
oci os object put \
  --bucket-name delta-copy-scripts \
  --file Delta_Incremental_Copy.py \
  --name Delta_Incremental_Copy.py
```

### 4. IAM Policies

Create a policy in the root compartment:

```bash
oci iam policy create \
  --compartment-id $TENANCY \
  --name "delta-copy-policies" \
  --description "Policies for Data Flow and Data Integration" \
  --statements '[
    "Allow service dataflow to read objects in tenancy",
    "Allow service dataflow to manage objects in tenancy",
    "Allow service dataintegration to manage dataflow-family in tenancy",
    "Allow service dataintegration to manage objects in tenancy",
    "Allow group Administrators to manage dataflow-family in tenancy",
    "Allow group Administrators to manage dis-workspaces in tenancy",
    "Allow group Administrators to manage dis-family in tenancy"
  ]'
```

---

## Setup Guide

### Step 1 — Configure Variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your OCI credentials, bucket URIs, script
arguments, compute shapes, and schedule configuration.

### Step 2 — Deploy

```bash
terraform init
terraform plan     # Review — should show 8 resources
terraform apply    # Confirm with 'yes'
```

The Data Integration workspace takes ~9 minutes to create. All other resources
are created in seconds. Once complete, the pipeline is live and will run daily
at the configured time.

---

## Configurable Parameters

All resource names, compute shapes, and script arguments are Terraform
variables. Key ones:

| Variable                  | Purpose                                   | Default                  |
|---------------------------|-------------------------------------------|--------------------------|
| `dataflow_display_name`   | Data Flow app name                        | `DeltaIncrementalCopy`   |
| `driver_shape`            | Spark driver compute shape                | `VM.Standard.E4.Flex`    |
| `executor_shape`          | Spark executor compute shape              | `VM.Standard.E4.Flex`    |
| `driver_shape_ocpus`      | OCPUs for the driver                      | `1`                      |
| `executor_shape_ocpus`    | OCPUs per executor                        | `1`                      |
| `driver_shape_memory_gb`  | Memory (GB) for the driver                | `16`                     |
| `executor_shape_memory_gb`| Memory (GB) per executor                  | `16`                     |
| `num_executors`           | Number of Spark executors                 | `1`                      |
| `source_path`             | Source Delta table OCI URI                | *(required)*             |
| `dest_path`               | Destination Delta table OCI URI           | *(required)*             |
| `time_column`             | Timestamp column for incremental filter   | `load_timestamp`         |
| `tenancy_column`          | Tenancy filter column                     | `tenancy_id`             |
| `lookback_days`           | Initial-import lookback (null = all)      | `null`                   |
| `schedule_hour`           | Hour (0-23) for daily run                 | `2`                      |
| `schedule_minute`         | Minute (0-59) for daily run               | `0`                      |
| `schedule_timezone`       | IANA timezone                             | `UTC`                    |
| `di_workspace_name`       | DI workspace display name                 | `delta-copy-workspace`   |
| `di_task_name`            | DI task display name                      | `DeltaCopyDailyRun`      |

See `variables.tf` for the full list with descriptions and defaults.

## Spark Configuration

The Data Flow application includes these Spark properties:

| Property                                              | Value   |
|-------------------------------------------------------|---------|
| `spark.oracle.deltalake.version`                      | `3.1.0` |
| `spark.hadoop.fs.oci.client.multiregion.enabled`      | `true`  |

## Cleanup

```bash
terraform destroy
```

This removes the compartment and all Terraform-managed resources. The
pre-existing buckets and IAM policies are not affected.
