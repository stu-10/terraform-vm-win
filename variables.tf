#region authentication
    variable "prismUser" {
        default = "stuart.jennings@ukdemo.local"
    }
    variable "prismSecret" {
        default = "Nutanix123!!!"
    }
    variable "prismEndpoint" {
        default = "192.168.2.40"  
    }
    variable "prismPort" {
        default = "9440"
    }
#endregion

#region cluster information
    variable nutanix_image {
        default = "SJ-Win2016-Sysypreped"
    }
    variable nutanix_network {
        default = "dnd-stuart.jennings"
    }
#endregion

#region vm configuration
    variable "cpu" { 
        default = "1"
    }
    variable "ram" {
        default = "2048"
    }
    variable "qty" {
        default = "1"
    }
    variable "dataDiskSizeMib" {
        default = 51200
    }
#endregion

#region vm customization
    variable "vmName" {
        default = "sj-tf"
    }
    variable "domain" {}
    variable "subnetMask" {
        default = "255.255.255.0"
    }
    variable "dns1" {}
    variable "dns2" {}
#endregion