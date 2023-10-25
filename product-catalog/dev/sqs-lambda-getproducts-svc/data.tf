resource "null_resource" "npm_install" {
  triggers = {
    timestamp = "${replace("${timestamp()}", "/[-| |T|Z|:]/", "")}"
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/assets/ && npm install -d && npx tsc lambda-script.ts"
  }
}
