# Beacon Brand Asset Package

This production package is derived directly from the approved, tracked PNG masters in `Images/Brand/Masters`. No lighthouse or wave geometry is redrawn.

## Source-of-truth masters

- `Masters/beacon-mark-full-color-approved.png` — transparent full-color mark with lighthouse, two separate waves, and beams.
- `Masters/beacon-mark-simplified-approved.png` — transparent mark with two separate waves and no beams.
- `Masters/beacon-mark-one-color-navy-approved.png` — transparent navy mark for restricted-color use.
- `Masters/beacon-mark-white-reference-approved.png` — approved white reference artwork.
- `Masters/beacon-mark-reversed-approved.png` — approved light artwork on a dark background.
- `Masters/beacon-lockup-approved.png` — approved transparent Beacon horizontal lockup.

The raster masters are the highest-fidelity supplied sources, so this package uses large transparent PNGs rather than claiming raster traces are true vectors.

## Deliverables

- `beacon.ico` — Windows icon with 16, 24, 32, 48, 64, 128, and 256-pixel frames.
- `Browser/` — favicon sizes, multi-size favicon, and web manifest.
- `PNG/Application/` — 16–512-pixel application icons.
- `PNG/Brand/` — large transparent full-color, simplified, navy, and white marks plus the reversed version.
- `Tray/` — navy and white no-beam tray assets plus notification icons.
- `Web/` — light/dark header and login artwork, including the 450×66 server-header asset required by the upstream branding hook.
- `Installer/` — application icons, uninstall-entry icon, and 164×314 sidebar PNG/BMP.
- `Lockups/` — Beacon, Beacon Remote, Beacon Agent, and Beacon Assistant lockups.

Run `powershell -ExecutionPolicy Bypass -File .\Images\Brand\build-assets.ps1` from the repository root to regenerate the package from the tracked approved masters.
