# ------------------------------------------------------------------------------
# Test Compartment
# ------------------------------------------------------------------------------
# The client will manually create IAM policies and OCI buckets.
# This compartment is for grouping the Data Flow + Data Integration resources.

resource "oci_identity_compartment" "this" {
  compartment_id = var.tenancy_ocid
  name           = var.compartment_name
  description    = var.compartment_description
  enable_delete  = true
}
