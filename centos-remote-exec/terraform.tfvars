# ======================== #
# VMware VMs configuration #
# ======================== #

vm-count = "2"
vm-name = "tftest"
vm-template-name = "CentOS7-T-2020-02-16"
vsphere-template-folder = "Templates"
vm-cpu = 2
vm-ram = 4096
vm-disk-size = 80
vm-guest-id = "centos7_64Guest"
vm-resource-pool = "Terraform"
vm-folder = "Terraform"
vsphere-datacenter = "Labs-DC02"
vsphere-cluster = "DC02-Cluster"
vm-datastore = "SSD_DATASTORE"
vm-network = "vlan100"
vm-domain = "corp.local"

vm-annotation = "Create by Terraform"

# ============================ #
# vm tags and category         #
# ============================ #
vm-tag-category = "terraform-test-category"
vm-tag-list = ["web-443", "web-80"]

# ============================ #
# VM Custom Notes              #
# ============================ #
vm-application = "WebServer"
vm-owner = "Terraform-user"


# ============================ #
# VM SSH Authority             #
# ============================ #
ssh-user = "root"
ssh-password = "VMware1!"

# ============================ #
# VMware vSphere configuration #
# ============================ #

# VMware vCenter IP/FQDN
vsphere-vcenter = "vcenter.corp.local"

# VMware vSphere username used to deploy the infrastructure
vsphere-user = "administrator@vsphere.local"

# VMware vSphere password used to deploy the infrastructure
vsphere-password = "VMware1!"

# Skip the verification of the vCenter SSL certificate (true/false)
vsphere-unverified-ssl = "true"

