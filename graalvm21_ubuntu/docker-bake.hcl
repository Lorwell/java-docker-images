group "default" {
  targets = ["graalvm21_ubuntu.build","graalvm21_ubuntu22.runtime"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "graalvm21_ubuntu.build" {
  context = "."
  dockerfile = "graalvm21_ubuntu/build.dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:graalvm21_ubuntu22.build"]
}

target "graalvm21_ubuntu22.runtime" {
  context = "."
  dockerfile = "graalvm21_ubuntu/runtime.dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:graalvm21_ubuntu22.runtime"]
}

