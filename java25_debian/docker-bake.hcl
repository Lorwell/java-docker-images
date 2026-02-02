group "default" {
  targets = ["25_debian"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "25_debian" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:25_debian"]
}

