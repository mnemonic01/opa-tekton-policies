package cicd

default allow = false

deny[msg] if {
  not input.sbom.present
  msg := "SBOM missing: build is blocked according to CI/CD policy"
}

allow if {
  input.sbom.present
}