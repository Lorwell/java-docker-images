group "default" {
  targets = ["graalvm25_debian_jre"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "graalvm25_debian_jre" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:graalvm25_debian12.jre"]
}
