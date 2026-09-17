# Phase 3.5 — Baseline Beacon Remote Identity

## Status

Not started. This phase is a hard gate before Phase 4 and before any persistent staging or production application environment is created.

Phase 3 proved that Hudson Helm can build and start a traceable image from this fork. The resulting smoke-test image retains upstream user-facing identity and is not approved for persistent deployment. Phase 3.5 must establish the baseline Beacon Remote identity first.

## Naming Contract

| Name | Meaning |
|---|---|
| **Beacon** | Product family |
| **Beacon Remote** | This remote-management product |
| **Beacon Agent** | Managed endpoint agent |
| **Beacon Assistant** | Tray and support-assistant component |

User-facing references must use the component-appropriate name. **Beacon** alone must not replace **Beacon Remote** when identifying this product.

## Required Scope

Normal technician and customer operation must not expose **MeshCentral**, **MeshAgent**, or **MeshCentral Assistant** as product branding. The implementation and validation must cover:

- product, page, browser, login, and header titles;
- installer and client presentation;
- notifications, prompts, and support-session UI;
- logos, icons, and favicon;
- generated downloads/installers and their customer-visible names and labels;
- Windows Apps & Features and uninstall entries;
- Windows Services;
- Start Menu and tray presentation;
- installer dialogs; and
- executable metadata where practical.

Use **Beacon Remote**, **Beacon Agent**, and **Beacon Assistant** as appropriate.

## Boundaries and Maintainability

- Preserve copyright notices, license text, and upstream attribution wherever legally or technically required.
- Keep internal source, package, executable, storage, database, configuration, and protocol identifiers unchanged where renaming would create needless divergence or compatibility risk and the identifiers are not ordinarily exposed as branding.
- Centralize branding values and assets behind configuration or a small, documented branding layer.
- Prefer existing upstream configuration and branding hooks before modifying source.
- Avoid broad string replacement and record every Hudson-specific customization.
- Verify that a clean rebuild reproduces the approved identity and that the approach remains practical to carry through upstream merges.

## Acceptance Record

Complete this record with evidence before closing the phase.

- [ ] Routine technician operation exposes no MeshCentral, MeshAgent, or MeshCentral Assistant product branding.
- [ ] Routine customer operation, including persistent and temporary support-component use, exposes none of those upstream product names.
- [ ] Web titles, login/header UI, notifications, prompts, and support-session UI use approved Beacon Remote component names.
- [ ] Logos, icons, and favicon use approved Beacon/Hudson Helm assets.
- [ ] Generated downloads/installers and their customer-visible file names and labels use approved names.
- [ ] Apps & Features, uninstall entries, Windows Services, Start Menu, tray, and installer dialogs use approved names.
- [ ] Readily visible executable metadata uses approved names wherever practical.
- [ ] Required legal notices and upstream attribution remain intact and accessible.
- [ ] Branding is centralized/configurable and survives a clean rebuild.
- [ ] Hudson-specific changes are documented and assessed for upstream-merge impact.
- [ ] Every unavoidable user-visible upstream name has a documented legal or technical reason and explicit acceptance.

## Exit Gate

Phase 3.5 passes only when every acceptance item above is complete and the evidence and any explicitly accepted exceptions are recorded here.

**Phase 4 cannot begin, and no persistent staging or production application environment may be created, until Phase 3.5 passes.**
