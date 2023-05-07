
resource "aws_vpc_endpoint" "default" {

  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Resource = "*"
      }
    ]
  })

}
# resource "aws_route" "dynamodb_endpoint" {
#   route_table_id         = module.vpc.private_route_table_ids[0]
#   destination_cidr_block = "com.amazonaws.${var.region}.dynamodb"
#   vpc_endpoint_id        = aws_vpc_endpoint.default.id
# }
resource "aws_vpc_endpoint_route_table_association" "private-dynamodb" {
    vpc_endpoint_id = "${aws_vpc_endpoint.default.id}"
    route_table_id  = "${module.vpc.private_route_table_ids[0]}"
  }
