group "default" {
  targets = ["graalvm25_debian-build","graalvm25_debian-runtime"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "graalvm25_debian-build" {
  context = "."
  dockerfile = "build.dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:graalvm25_debian12.build"]
}

target "graalvm25_debian-runtime" {
  context = "."
  dockerfile = "runtime.dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:graalvm25_debian12.runtime"]
}

