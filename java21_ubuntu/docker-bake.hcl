group "default" {
  targets = ["21_ubuntu"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "21_ubuntu" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:21_ubuntu"]
}