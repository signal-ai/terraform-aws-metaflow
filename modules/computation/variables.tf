variable "batch_type" {
  type        = string
  description = "AWS Batch Compute Type ('ec2', 'fargate', 'spot')"
  default     = "ec2"

  validation {
    condition     = contains(["ec2", "fargate", "spot"], var.batch_type)
    error_message = "Allowed values for input_parameter are 'ec2', 'fargate', 'spot'."
  }
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
}

variable "compute_environment_instance_types" {
  type        = list(string)
  description = "The instance types for the compute environment as a comma-separated list"
}

variable "compute_environment_max_vcpus" {
  type        = number
  description = "Maximum VCPUs for Batch Compute Environment [16-96]"
}

variable "compute_environment_min_vcpus" {
  type        = number
  description = "Minimum VCPUs for Batch Compute Environment [0-16] for EC2 Batch Compute Environment (ignored for Fargate)"
}

variable "ecs_cluster_id" {
  type        = string
  default     = null
  description = "The ID of an existing ECS cluster to run services on. If no cluster ID is specfied, a new cluster will be created."
}

variable "enable_step_functions" {
  default     = false
  description = "If true, apply policies required for step functions"
  type        = bool
}

variable "iam_partition" {
  type        = string
  default     = "aws"
  description = "IAM Partition (Select aws-us-gov for AWS GovCloud, otherwise leave as is)"
}

variable "metaflow_step_functions_dynamodb_policy" {
  type        = string
  description = "IAM policy allowing access to the step functions dynamodb policy"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix given to all AWS resources to differentiate between applications"
}

variable "resource_suffix" {
  type        = string
  description = "Suffix given to all AWS resources to differentiate between environment and workspace"
}

variable "metaflow_vpc_id" {
  type        = string
  description = "ID of the Metaflow VPC this SageMaker notebook instance is to be deployed in"
}

variable "standard_tags" {
  type        = map(string)
  description = "The standard tags to apply to every AWS resource."
}

variable "subnet1_id" {
  type        = string
  description = "The first private subnet used for redundancy"
}

variable "subnet2_id" {
  type        = string
  description = "The second private subnet used for redundancy"
}
