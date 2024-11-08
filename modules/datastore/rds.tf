/*
 A subnet is attached to an availability zone so for db redundancy and
 performance we need to define additional subnet(s) and aws_db_subnet_group
 is how we define this.
*/
resource "aws_db_subnet_group" "this" {
  name       = local.pg_subnet_group_name
  subnet_ids = [var.subnet1_id, var.subnet2_id]

  tags = merge(
    var.standard_tags,
    {
      Name     = local.pg_subnet_group_name
      Metaflow = "true"
    }
  )
}

/*
 Define a new firewall for our database instance.
*/
resource "aws_security_group" "rds_security_group" {
  name   = local.rds_security_group_name
  vpc_id = var.metaflow_vpc_id

  # ingress only from port 5432
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.metadata_service_security_group_id]
  }

  # egress to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.standard_tags
}

resource "random_password" "this" {
  length  = 64
  special = true
  # redefines the `special` variable by removing the `@`
  # this documentation https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html
  # shows that the `/`, `"`, `@` and ` ` cannot be used in the password
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "rds_db_password" {
  name = "${var.resource_prefix}${var.db_name}_password${var.resource_suffix}"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.rds_db_password.id
  secret_string = random_password.this.result
}

resource "random_pet" "final_snapshot_id" {}

/*
 Define rds db instance.
*/
resource "aws_db_instance" "this" {
  publicly_accessible       = false
  allocated_storage         = 20    # Allocate 20GB
  storage_type              = "gp2" # general purpose SSD
  storage_encrypted         = true
  kms_key_id                = aws_kms_key.rds.arn
  engine                    = "postgres"
  engine_version            = var.postgres_engine_version
  instance_class            = var.db_instance_type                                         # Hardware configuration
  identifier                = "${var.resource_prefix}${var.db_name}${var.resource_suffix}" # used for dns hostname needs to be customer unique in region
  name                      = var.db_name                                                  # unique id for CLI commands (name of DB table which is why we're not adding the prefix as no conflicts will occur and the API expects this table name)
  username                  = var.db_username
  password                  = random_password.this.result
  db_subnet_group_name      = aws_db_subnet_group.this.id
  max_allocated_storage     = 1000                                                                                                           # Upper limit of automatic scaled storage
  multi_az                  = true                                                                                                           # Multiple availability zone?
  final_snapshot_identifier = "${var.resource_prefix}${var.db_name}-final-snapshot${var.resource_suffix}-${random_pet.final_snapshot_id.id}" # Snapshot upon delete
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]

  tags = merge(
    var.standard_tags,
    {
      Name     = "${var.resource_prefix}${var.db_name}${var.resource_suffix}"
      Metaflow = "true"
    }
  )
}
