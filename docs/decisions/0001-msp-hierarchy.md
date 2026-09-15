# ADR 0001: Fixed MSP Hierarchy

- Status: Accepted
- Date: 2026-09-15
- Phase: 0

## Decision

Beacon will use a fixed three-level operational hierarchy:

```text
Customer
└── Site
    └── Device
```

Tags will provide cross-cutting organization such as department, role, service tier, operating system, or policy cohort. The first implementation should map each site to a MeshCentral device group where practical. A thin Beacon organizational layer may associate those site groups with customers, but it must not replace MeshCentral's authorization model without a demonstrated need.

## Rationale

- Small-MSP navigation stays predictable: technicians choose a customer, then a site, then a device.
- Permission boundaries and reporting totals have stable meanings.
- Site-level policy inheritance is understandable and sufficient for the expected initial scale.
- MeshCentral already provides device groups, per-group permissions, device permissions, search, and tags, so the model minimizes source divergence.
- Licensing and future monitoring can aggregate cleanly by customer and site.
- Importing or mapping existing device groups is simpler than migrating arbitrary nested folders and inherited permissions.

## Alternatives Considered

Arbitrary nesting would support structures such as Customer → Region → Site → Department → Device, but it adds path management, permission inheritance, navigation, reporting, and migration complexity before real Hudson Helm usage demonstrates that need. Tags cover departments and other overlapping classifications more naturally than a single deep tree.

## Consequences and Guardrails

- A device belongs to one operational site at a time.
- Customers may have any number of sites, including one default site for single-location customers.
- Tags are not security boundaries unless a later decision explicitly defines and implements that behavior.
- Customer-level access should expand to its sites; site-level access should remain limited to that site.
- Domains must not be used as a customer hierarchy by default because MeshCentral domains isolate users and administration more strongly than ordinary MSP grouping requires.
- The data model should use stable identifiers rather than encoded display-name paths.
- If real use later requires regional rollups or deeper policy inheritance, add an optional grouping layer through a new ADR and a documented migration rather than silently changing this contract.

## Upstream Fit

MeshCentral's current model provides domains, device groups (meshes), nodes, tags, and permissions at global, device-group, and device levels. Beacon will reuse those primitives first and add the smallest possible customer association needed for the selected hierarchy.
