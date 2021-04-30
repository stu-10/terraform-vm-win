terraform {
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
      version = "1.2.0"
    }
  }
}

#region provider
provider "nutanix" {
  username = "${var.prismUser}"
  password = "${var.prismSecret}"
  endpoint = "${var.prismEndpoint}"
  insecure = true
  port = "${var.prismPort}"
}
#endregion

#region data
    data "nutanix_subnet" "ahv_network" {
        subnet_name = "${var.nutanix_network}"
    }
    data "nutanix_image" "image" {
        image_name = "${var.nutanix_image}"
    }
    data "nutanix_clusters" "clusters" {}
    locals {
        cluster = data.nutanix_clusters.clusters.entities[0].metadata.uuid
    }
    data "nutanix_cluster" "cluster" {
        cluster_id = "${local.cluster}"
    }
    data "template_file" "unattend" {
        template = "${file("sysprep.xml")}"
        vars = {
            vm_name = "${var.vmName}"
        }
    }
#endregion

#region resources
    resource "nutanix_virtual_machine" "vm" {
        count = "${var.qty}"
        name = "${var.vmName}-${count.index + 1}"

        cluster_uuid = "${data.nutanix_cluster.cluster.id}"

        nic_list {
            subnet_uuid = "${data.nutanix_subnet.ahv_network.id}"
        }

        disk_list {
            data_source_reference = {
                kind = "image"
                uuid = "${data.nutanix_image.image.id}"
            }

        }

        disk_list {
            device_properties {
                disk_address = {
                    device_index = 1
                    adapter_type = "SCSI"
                }
                device_type = "DISK"
            }
            disk_size_mib   = "${var.dataDiskSizeMib}"
        }

        num_vcpus_per_socket = 1
        num_sockets          = "${var.cpu}"
        memory_size_mib      = "${var.ram}"
        guest_customization_sysprep = {
            install_type = "PREPARED"
            #unattend_xml = data.template_file.unattend.rendered
            unattend_xml = base64encode(data.template_file.unattend.rendered)
        }
    }
#endregion
