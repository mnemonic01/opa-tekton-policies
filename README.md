# opa-tekton-policies
Reusable OPA policy checks for Tekton CI/CD pipelines
## Architecture overview

```mermaid
flowchart LR
    A[Tekton Pipeline] --> B[OPA Policy Check Task]
    C[Rego Policy] --> B
    D[Input JSON] --> B
    B --> E{Allow?}
    E -->|Yes| F[Pipeline continues]
    E -->|No| G[Pipeline fails]
