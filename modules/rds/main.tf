# KMS Key for RDS
resource "aws_kms_key" "kms" {
  description = "KMS key for RDS"
}

data "aws_rds_engine_version" "current" {
  engine         = var.db_engine
  version        = var.db_version
}


# Security group for RDS instance
resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.cluster_prefix}-${var.db_environment}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id = var.vpc_id
  
  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip  # Consider restricting this to your IP range or VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_prefix}-${var.db_environment}-rds-sg"
  }
}

# Subnet group for RDS instance
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.cluster_prefix}-${var.db_environment}-rds-sng"
  subnet_ids = var.subnet_ids
  description = "Subnet group for RDS instance"

  tags = {
    Name = "${var.cluster_prefix}-${var.db_environment}-rds-sng"
  }
  depends_on = [
     aws_security_group.rds_sg
   ]
}

# RDS instance
resource "aws_db_instance" "db_instance" {
  allocated_storage             = var.db_storage
  # identifier = "${lower(var.cluster_prefix)}-${lower(var.db_environment)}-db"
  identifier  = "${lower(var.cluster_prefix)}-${lower(var.db_environment)}-db"
  db_name                       = var.db_name
  engine                        = var.db_engine
  engine_version                = var.db_version
  instance_class                = var.db_instance_class

  vpc_security_group_ids        = [aws_security_group.rds_sg.id]
  db_subnet_group_name          = aws_db_subnet_group.subnet_group.name

  # manage_master_user_password   = true
  # master_user_secret_kms_key_id = aws_kms_key.kms.key_id
  username                      = var.db_username
  password                      = var.db_password
  skip_final_snapshot           = true
  delete_automated_backups      = true

  tags = {
    Name = "${var.cluster_prefix}-${var.db_environment}-db"
  }
  depends_on = [ aws_db_subnet_group.subnet_group, aws_security_group.rds_sg ]
}
