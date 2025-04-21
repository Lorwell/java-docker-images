group "default" {
  targets = ["21_ubuntu22_ffmpeg"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/moailaozi"
}

target "21_ubuntu22_ffmpeg" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["${IMAGE_REGISTRY}/jre:21_ubuntu22_ffmpeg"]
}