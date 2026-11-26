resource "null_resource" "enable_schema_registry" {

  triggers = {
    environment_id = var.environment_id
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -eu
      V=3.65.0
      OS=$(uname -s | tr '[:upper:]' '[:lower:]')
      ARCH=$(uname -m)
      case "$ARCH" in x86_64) ARCH=amd64 ;; aarch64|arm64) ARCH=arm64 ;; esac
      BASE="https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/$V"
      TARBALL="confluent_"$V"_"$OS"_"$ARCH".tar.gz"
      curl -sSfL --http1.1 -o "$TARBALL" "$BASE/$TARBALL"
      curl -sSfL --http1.1 -o confluent_checksums.txt "$BASE/confluent_"$V"_checksums.txt"
      if command -v sha256sum >/dev/null 2>&1; then SUM="sha256sum"; else SUM="shasum -a 256"; fi
      WANT=$(awk -v f="$TARBALL" '$2==f {print $1}' confluent_checksums.txt)
      GOT=$($SUM "$TARBALL" | awk '{print $1}')
      test -n "$WANT"
      test "$WANT" = "$GOT"
      tar -xzf "$TARBALL"
      mkdir -p ./bin
      install ./confluent/confluent ./bin/confluent
      rm -rf ./confluent "$TARBALL" confluent_checksums.txt
    EOT
  }

  provisioner "local-exec" {
    command = "./bin/confluent version"
  }

  provisioner "local-exec" {
    command = "./bin/confluent login --organization-id ${var.confluent_organization_id} --save"

    environment = {
      CONFLUENT_CLOUD_EMAIL    = var.confluent_cloud_email
      CONFLUENT_CLOUD_PASSWORD = var.confluent_cloud_password
    }
  }

  provisioner "local-exec" {
    command = "./bin/confluent environment use ${var.environment_id}"
  }

  provisioner "local-exec" {
    command = "./bin/confluent schema-registry cluster enable --cloud ${var.schema_registry_cloud} --geo ${var.schema_registry_geo} 1> schema-registry-result.txt 2> schema-registry-error.txt"
  }

  provisioner "local-exec" {
    command = "cat schema-registry-result.txt"
  }

  provisioner "local-exec" {
    command = "cat schema-registry-error.txt"
  }
}
