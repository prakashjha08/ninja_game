output "vpc_id" {
  value = aws_vpc.name.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.privatee_subnet.*.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.ngw.id
}
