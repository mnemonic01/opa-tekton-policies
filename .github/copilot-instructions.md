# GitHub Copilot / AI agent instructions for opa-tekton-policies

## Purpose ✨
- Short: provide reusable Open Policy Agent (OPA) Rego checks that run inside Tekton CI pipelines.
- Key files: `policies/*.rego` (policy modules), `tekton/opa-policy-check-task.yaml` (Task that runs `opa eval`), `examples/pipeline.yaml` (pipeline example / placeholder).

## Big picture 🧭
- Policies are written as Rego modules under `package cicd` and expose a boolean `allow` decision (checked as `data.cicd.allow`).
- The Tekton task `opa-policy-check` runs the OPA image and evaluates the configured `policy` and `input` against the `query` defaulting to `data.cicd.allow`.
- The task fails the pipeline unless the evaluated decision is exactly `true` (the task checks for `"value":true` in the JSON output).

## Patterns & conventions to follow 🔧
- Use `package cicd` in all policies so the decision is `data.cicd.allow` (this is what the Tekton task queries).
- Start with `default allow = false` and add `allow` rules that become true for acceptable inputs (see `policies/sbom-required.rego`).
- Make the exported decision a boolean `true`/`false` to match the Tekton task's simple JSON check.
- Policy filenames live in `policies/` — add new `.rego` files there and reference them via `--data` when testing or in the task inputs.

## Concrete examples & commands ✅
- Evaluate a single policy locally:

  opa eval --format=json --data policies/sbom-required.rego --input <(echo '{"sbom":{"generated":true}}') 'data.cicd.allow'

- Evaluate with local file input:

  printf '{"sbom":{"generated":true}}' > input.json
  opa eval --format=json --data policies/sbom-required.rego --input input.json 'data.cicd.allow'

- Debug why a policy denied (explain):

  opa eval --format=json --explain=full --data policies/sbom-required.rego --input input.json 'data.cicd.allow'

- How Tekton runs it (see `tekton/opa-policy-check-task.yaml`): it runs `opa eval --format=json --data $(params.policy) --input $(params.input) "$(params.query)"` and fails if the JSON output does not contain `"value":true`.

## Integration points & notes 🧩
- Tekton Task params defaults: `policy=policy.rego`, `input=input.json`, `query=data.cicd.allow`.
- Workspace `source` is expected to contain the policy and input files in CI. When adding a pipeline, ensure it mounts a workspace with those files.
- The OPA image used is `openpolicyagent/opa:latest`. Keep in mind pinning to a release may be desirable for reproducibility.

## Repo-specific quirks / current state ⚠️
- `policies/no-secrets.rego` and `policies/base-image.rego` are currently empty stubs — treat them as places to add concrete checks following the `sbom-required` example.
- `examples/pipeline.yaml` is a placeholder; tests and example pipelines are not present in the repo.

## How to extend or test a change 🧪
1. Add or modify `policies/*.rego` using `package cicd` and `default allow = false`.
2. Add a small JSON `input.json` that mimics pipeline-generated input (e.g., `{ "sbom": { "generated": true } }`).
3. Run the `opa eval` commands above to validate the boolean decision.
4. If adding to CI, update or create a Tekton pipeline (in `examples/`) that invokes `tekton/opa-policy-check-task.yaml` with the correct workspace.

---

If anything here is unclear or you want extra examples (e.g., a test harness, pinned OPA version, or a sample pipeline), tell me which bits to expand and I will iterate. 🎯