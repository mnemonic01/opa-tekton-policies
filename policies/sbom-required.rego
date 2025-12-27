package cicd

# Default: deny
default allow = false

# Allow when an SBOM is generated
allow {
  input.sbom.generated == true
}