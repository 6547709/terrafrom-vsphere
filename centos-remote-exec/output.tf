# output the vm ip address
output "my_ip_address" {
 value = vsphere_virtual_machine.vm.*.default_ip_address
}