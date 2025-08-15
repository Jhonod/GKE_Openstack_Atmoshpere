variable "project_id" { type = string }
variable "region"     { type = string, default = "asia-southeast2" }
variable "zone"       { type = string, default = "asia-southeast2-a" }

variable "cluster_name" { type = string, default = "gke-openstack" }
variable "network"      { type = string, default = "gke-openstack-net" }
variable "subnetwork"   { type = string, default = "gke-openstack-subnet" }

variable "node_count"         { type = number, default = 3 }
variable "node_machine_type"  { type = string, default = "e2-standard-4" }

variable "tfstate_bucket" { type = string } # required
