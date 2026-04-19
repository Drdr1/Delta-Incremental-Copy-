tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaxrbjmjyrt3dyryi5bwxszwynwpfwe7vez7ydufddjdi5rhb5wc5q"
user_ocid        = "ocid1.user.oc1..aaaaaaaaacvsdattnrs6doeyzhedfomi2l6n2btl46dvaybmsembxqhs6ypq"
fingerprint      = "61:76:f9:d6:38:04:f9:6f:95:1c:6f:8a:6e:1b:13:a6"
private_key_path = "~/.oci/oci_api_key.pem"
region           = "us-ashburn-1"

compartment_id   = "ocid1.tenancy.oc1..aaaaaaaaxrbjmjyrt3dyryi5bwxszwynwpfwe7vez7ydufddjdi5rhb5wc5q"

script_file_uri  = "oci://delta-copy-scripts@idfnvtzcpptm/Delta_Incremental_Copy.py"
logs_bucket_uri  = "oci://dataflow-logs@idfnvtzcpptm/"

source_path      = "oci://delta-copy-source@idfnvtzcpptm/delta_table"
dest_path        = "oci://delta-copy-dest@idfnvtzcpptm/delta_table"
time_column      = "load_timestamp"
tenancy_column   = "tenancy_id"
lookback_days    = 30

