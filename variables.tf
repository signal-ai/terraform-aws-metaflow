variable "access_list_cidr_blocks" {
  type        = list(string)
  description = "List of CIDRs we want to grant access to our Metaflow Metadata Service. Usually this is our VPN's CIDR blocks."
  default     = []
}

variable "api_basic_auth" {
  type        = bool
  default     = true
  description = "Enable basic auth for API Gateway? (requires key export)"
}

variable "batch_type" {
  type        = string
  description = "AWS Batch Compute Type ('ec2', 'fargate', 'spot')"
  default     = "ec2"

  validation {
    condition     = contains(["ec2", "fargate", "spot"], var.batch_type)
    error_message = "Allowed values for input_parameter are 'ec2', 'fargate', 'spot'."
  }
}

variable "db_instance_type" {
  type        = string
  description = "RDS instance type to launch for PostgresQL database."
  default     = "db.t2.small"
}

variable "enable_custom_batch_container_registry" {
  type        = bool
  default     = false
  description = "Provisions infrastructure for custom Amazon ECR container registry if enabled"
}

variable "enable_step_functions" {
  type        = bool
  description = "Provisions infrastructure for step functions if enabled"
}

variable "resource_prefix" {
  default     = "metaflow"
  description = "string prefix for all resources"
}

variable "resource_suffix" {
  default     = ""
  description = "string suffix for all resources"
}

variable "compute_environment_ami_id" {
  type        = string
  description = "The AMI ID to use for Batch Compute Environment EC2 instances. If not specified, defaults to the latest ECS optimised AMI."
  default     = null
}

variable "compute_environment_user_data_base64" {
  type        = string
  default     = null
  description = "Base64 hash of the user data to use for Batch Compute Environment EC2 instances."
}

variable "compute_environment_spot_bid_percentage" {
  type        = number
  default     = 100
  description = "The maximum percentage of on-demand EC2 instance price to bid for spot instances when using the 'spot' AWS Batch Compute Type."
}

variable "compute_environment_desired_vcpus" {
  type        = number
  description = "Desired Starting VCPUs for Batch Compute Environment [0-16] for EC2 Batch Compute Environment (ignored for Fargate)"
  default     = 8
}

variable "compute_environment_instance_types" {
  type        = list(string)
  description = "The instance types for the compute environment"
  default     = ["c4.large", "c4.xlarge", "c4.2xlarge", "c4.4xlarge", "c4.8xlarge"]
}

variable "compute_environment_min_vcpus" {
  type        = number
  description = "Minimum VCPUs for Batch Compute Environment [0-16] for EC2 Batch Compute Environment (ignored for Fargate)"
  default     = 8
}

variable "compute_environment_max_vcpus" {
  type        = number
  description = "Maximum VCPUs for Batch Compute Environment [16-96]"
  default     = 64
}

variable "ecs_cluster_id" {
  type        = string
  default     = null
  description = "The ID of an existing ECS cluster to run services on. If no cluster ID is specfied, a new cluster will be created."
}

variable "iam_partition" {
  type        = string
  default     = "aws"
  description = "IAM Partition (Select aws-us-gov for AWS GovCloud, otherwise leave as is)"
}

variable "metadata_service_container_image" {
  type        = string
  default     = ""
  description = "Container image for metadata service"
}

variable "postgres_engine_version" {
  type        = string
  description = "Postgres engine version to use for Metaflow database."
  default     = "11"
}

variable "ui_static_container_image" {
  type        = string
  default     = ""
  description = "Container image for the UI frontend app"
}

variable "tags" {
  description = "aws tags"
  type        = map(string)
}

variable "ui_alb_internal" {
  type        = bool
  description = "Defines whether the ALB for the UI is internal"
  default     = false
}

# variables from infra project that defines the VPC we will deploy to

variable "subnet1_id" {
  type        = string
  description = "First subnet used for availability zone redundancy"
}

variable "subnet2_id" {
  type        = string
  description = "Second subnet used for availability zone redundancy"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The VPC CIDR block that we'll access list on our Metadata Service API to allow all internal communications"
}

variable "vpc_id" {
  type        = string
  description = "The id of the single VPC we stood up for all Metaflow resources to exist in."
}

variable "ui_certificate_arn" {
  type        = string
  description = "SSL certificate for UI. If no certificate arn is provided, HTTP will be used."
  default     = null
}

variable "ui_allow_list" {
  type        = list(string)
  default     = []
  description = "List of CIDRs we want to grant access to our Metaflow UI Service. Usually this is our VPN's CIDR blocks."
}

variable "extra_ui_backend_env_vars" {
  type        = map(string)
  default     = {}
  description = "Additional environment variables for UI backend container"
}

variable "extra_ui_static_env_vars" {
  type        = map(string)
  default     = {}
  description = "Additional environment variables for UI static app"
}
