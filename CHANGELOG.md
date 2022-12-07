## Unreleased

BUG FIXES:

* The `database_port` variable is now honoured in both the RDS database 
  instance and the security group where previously, it was only used in the
  security group.

ENHANCEMENTS:

* This module is now compatible with version 4 of the AWS provider.
* Variables have been added for `storage_type` and `storage_iops` allowing the 
  database storage type to be configured.
* A `max_allocated_storage` variable has been added allowing the maximum storage
  to be defined when storage autoscaling is in use.
* An `allow_public_access` variable has been added allowing the database
  instance to be exposed to the public Internet if required. Access is still
  controlled via the `private_network_cidr` variable and the security group so
  set this variable to `"0.0.0.0/0"` if you want to allow full public access.
* An `allow_major_version_upgrade` variable has been added allowing control over
  major version upgrades to the database instance.
* An `enable_automatic_minor_version_upgrade` variable has been added allowing
  control over whether minor upgrades can be applied automatically during the
  maintenance window.
* An `enable_performance_insights` variable has been added allowing performance
  insights to be enabled for the database instance.

## 1.0.0 (May 28th, 2021)

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module is now compatible with Terraform 0.14 and higher.

## 0.1.4 (September 9th, 2017) 

IMPROVEMENTS:

* The zone ID and the DNS name of the ELB are now output from the module.   