resource "aws_ecs_cluster" "this" {
  count = var.ecs_cluster_id != null ? 0 : 1
  name  = local.ecs_cluster_name

  tags = merge(
    var.standard_tags,
    {
      Name     = local.ecs_cluster_name
      Metaflow = "true"
    }
  )
}
