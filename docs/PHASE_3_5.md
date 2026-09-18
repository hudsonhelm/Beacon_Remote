# Phase 3.5 — Baseline Beacon Remote Identity

## Status

Implementation and Linux/container validation are complete. Phase acceptance remains blocked on the Windows installed-surface validation and the explicit exception described below. This phase remains a hard gate before Phase 4 and before any persistent staging or production application environment is created.

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
- [ ] Web titles, login/header UI, notifications, prompts, and support-session UI use approved Beacon Remote component names. Web and configured notification/prompt identity are verified; an installed Windows support-session test remains outstanding.
- [x] Logos, icons, and favicon use approved Beacon/Hudson Helm assets.
- [x] Generated downloads/installers and their customer-visible file names and labels use approved names.
- [ ] Apps & Features, uninstall entries, Windows Services, Start Menu, tray, and installer dialogs use approved names.
- [ ] Readily visible executable metadata uses approved names wherever practical.
- [x] Required legal notices and upstream attribution remain intact and accessible.
- [x] Branding is centralized/configurable and survives a clean rebuild.
- [x] Hudson-specific changes are documented and assessed for upstream-merge impact.
- [ ] Every unavoidable user-visible upstream name has a documented legal or technical reason and explicit acceptance.

## Implementation and Evidence

The implementation uses the centralized `docker/beacon-branding.json` overlay and the reproducible package in `Images/Brand`. It prefers upstream domain-branding hooks, limits source edits to targeted user-visible strings and Windows client metadata, and retains compatibility-sensitive internal identifiers such as the MeshAgent API type and upstream Assistant artifact key.

On 2026-09-18, commit `cf89519cf02a010443cfe44d010395f6d8765d21` was built from a clean archive as `beacon-remote:0.1.0-hudson.2`. The resulting image ID was `sha256:d644607ff117e0cc877a03a330f4a17feb4999c0b93238a9cf6b2b71844f0709`, and its OCI revision label matched the source commit. The Phase 3.5 checker and HTTPS smoke test passed, including the production-minified login script, title, manifest, favicon, configuration overlay, packaged assets, and license metadata.

The asset builder reproduced the checked-in package byte for byte. Direct inspection confirmed the generated header and login lockups display **Beacon Remote**. Browser validation of the exact image confirmed the rendered **Beacon Remote - Login** page, complete white Beacon Remote lockup, login controls, and working production script bundle. This visual validation caught and led to correction of a partial web-root override and a missing production-minification step before the final build.

Generated Windows artifacts were inspected without installing them:

- `BeaconAgent64.exe` was generated with the customer-visible Beacon Agent file name and Beacon Agent product/file description metadata.
- `BeaconAssistant.exe` was generated with the customer-visible Beacon Assistant file name, title, icon/configuration, and embedded Beacon settings.
- Configured consent, notification, service display, installer, tray, and uninstall presentation use the approved component names.

## Outstanding Acceptance Items

1. **Installed Windows surfaces are not yet directly validated.** No disposable Windows sandbox or VM is available in the current environment. Apps & Features, uninstall entries, Windows Services, Start Menu, tray, installer dialogs, and live support-session UI therefore remain unchecked. Installing an agent on the operator workstation was deliberately not used as a substitute for an isolated test target.
2. **Beacon Assistant retains upstream signed PE VersionInfo.** The generated Assistant is distributed under the branded file name and presentation, but its signed executable still reports upstream `MeshCentral Assistant`/`MeshCentralAssistant.exe` VersionInfo. Editing that metadata would invalidate the valid upstream Authenticode signature. Closing the phase requires explicit acceptance of this technical exception or a separate Hudson-controlled signing solution followed by rebuilt metadata.

The build also reports three moderate npm audit findings in inherited build dependencies. They do not prevent the identity implementation or its smoke test, but they remain an upstream dependency-maintenance item and are not represented as resolved here.

## Exit Gate

Phase 3.5 passes only when every acceptance item above is complete and the evidence and any explicitly accepted exceptions are recorded here.

**Phase 4 cannot begin, and no persistent staging or production application environment may be created, until Phase 3.5 passes.**
