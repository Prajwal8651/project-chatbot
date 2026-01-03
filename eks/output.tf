output "cluster_id" {
  value = aws_eks_cluster.AskAI.id
}

output "node_group_id" {
  value = aws_eks_node_group.AskAI.id
}

output "vpc_id" {
  value = aws_vpc.AskAI_vpc.id
}

output "subnet_id" {
  value = aws_subnet.AskAI_subnet[*].id
}
