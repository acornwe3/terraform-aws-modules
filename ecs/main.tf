resource "aws_ecs_service" "service" {
  name = format("%s-%s-%s", var.project_name, var.environment, var.component)
  cluster = var.cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn

  desired_count = 1

  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery.arn
  }

  network_configuration {
    security_groups = [ var.subnet_egress_id, var.subnet_component_id, var.subnet_modules_id ]
    subnets         = var.subnet_nat_id
  }

  propagate_tags = "SERVICE"

  tags = {
    Department = "LAG"
    Project = var.project_name
    Environment = var.environment
  }
}


resource "aws_cloudwatch_log_group" "log" {
  name              = format("msel_lags-%s-%s", var.log_prefix, var.component)
  retention_in_days = 1
}

locals {
  db_host = format("db-%s.%s-local", var.component, var.environment)
}

resource "aws_ecs_task_definition" "task_definition" {
  family = format("%s-%s-%s", var.project_name, var.environment, var.component)
  network_mode = "awsvpc"
  container_definitions = <<EOF
  [
    {
      "name": "${var.component}",
      "image": "${var.image}",
      "portMappings": [
        {
          "containerPort": ${var.port},
          "hostPort": ${var.port}      
        }
      ],
      "environment": [{
        "name": "environment",
        "value": "${var.environment}"
      },
      ${var.environment_json}],
      "memory": ${var.memory},
      "cpu": ${var.cpu},
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${var.region}",
          "awslogs-group": "${aws_cloudwatch_log_group.log.name}",
          "awslogs-stream-prefix": "${var.log_prefix}"
        }
      }
    }
  ]
EOF
}

resource "aws_service_discovery_service" "service_discovery" {
  name = format("%s-%s-%s", var.project_name, var.environment, var.component)

  dns_config {
    namespace_id = var.dns_service_namespace

    dns_records {
      ttl  = 10
      type = "A" #A for awsvpc SRV for bridge
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}