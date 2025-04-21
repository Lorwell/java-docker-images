group "default" {
  targets = ["8_ubuntu22"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "8_ubuntu22" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:8_ubuntu22"]
}