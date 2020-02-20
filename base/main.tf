# ==================== #
# Deploying vSphere VM #
# ==================== #

# Connect to VMware vSphere vCenter
provider "vsphere" {
  user           = var.vsphere-user
  password       = var.vsphere-password
  vsphere_server = var.vsphere-vcenter

  # If you have a self-signed cert
  allow_unverified_ssl = var.vsphere-unverified-ssl
}

# Define VMware vSphere
data "vsphere_datacenter" "dc" {
  name = var.vsphere-datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vm-datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere-cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm-network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "/${var.vsphere-datacenter}/vm/${var.vsphere-template-folder}/${var.vm-template-name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_resource_pool" "resource_pool" {
  name        = var.vm-resource-pool
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_tag_category" "category" {
  name        = var.vm-tag-category
}

# ==================== #
# Get tag id from vars #
# ==================== #
data "vsphere_tag" "tag" {
  for_each    = toset(var.vm-tag-list)
  name        = each.value
  category_id = "${data.vsphere_tag_category.category.id}"
}

locals {
  tags = [
    for tag-id in data.vsphere_tag.tag :
      tag-id.id
    ]
}

# =================== #
# get CST Time.       #
# =================== #

locals {
   time = "${formatdate("YYYY-MM-DD hh:mm",timeadd(timestamp(),"8h"))}"
}

# Create VMs
resource "vsphere_virtual_machine" "vm" {
  count = var.vm-count
  name             = "${var.vm-name}-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vm-folder
  tags             = local.tags
  annotation       = "${var.vm-annotation}\nVM-Application:${var.vm-application}\nVM-Owner:${var.vm-owner}\nVM-CreateDate:${local.time}"
  num_cpus = var.vm-cpu
  memory   = var.vm-ram
  guest_id = var.vm-guest-id
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "${var.vm-name}-${count.index + 1}-disk"
    size  = var.vm-disk-size
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      timeout = 0
      linux_options {
        host_name = "${var.vm-name}-${count.index + 1}"
        domain    = var.vm-domain
      }
      network_interface {}
    }
  }
}
# limit the terraform version
terraform {
  required_version = ">= 0.12.20"
}