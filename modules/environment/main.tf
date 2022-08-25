# Random bucket suffix
resource "random_id" "suffix" {
  byte_length = 4
}

resource "confluent_environment" "env" {
  display_name = "${var.environment_name}-${random_id.suffix.hex}"
}
