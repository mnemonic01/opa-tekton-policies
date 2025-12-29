rego

package cicd

default allow = false

allow if {
  input.sbom.present == true
}