# Android Dev + KVM on Lenovo T14 — Design Spec

**Date:** 2026-10-18
**Target host:** `lenovo-t14` (this machine)
**Goal:** Declare, in Nix, a complete local Android development and runtime stack: KVM-accelerated qemu, an Android SDK, NDK, system image, Android Studio, and a one-command AVD creation flow — all reproducible via `nixos-rebuild switch`.

---

## 1. Goals & Non-Goals

### Goals
- Reproducible Android toolchain declared in Nix (no per-machine `sdkmanager` install dance, no licence-acceptance prompts).
- KVM acceleration enabled and ready before any user session starts an AVD.
- A single opt-in flag (`hendrik.android = true;`) gates the whole feature on `lenovo-t14`, mirroring the existing `hendrik.desktop = "gnome";` pattern.
- One Fish function (`mk-android-avd`) creates a working AVD on first use.
- Boot, smoke-test, and assembleDebug all flow without leaving the declarative config.

### Non-Goals
- Physical-device ADB / fastboot over USB (user explicitly opted out).
- Headless CI-grade AVD pool (no `services.android-emulator` socket activation).
- Cross-platform Android dev (Darwin). Other hosts (`syn`, `mac`, `ack`, `handcoding`, `megatron`) remain unaffected.
- GPU passthrough from a discrete GPU; the T14's Iris Xe iGPU is used directly by the emulator via `swiftshader_indirect`.

---

## 2. Architecture

Two new files, three small edits. The split mirrors the existing `system/` ↔ `home-manager/` boundary already established in this repo.

| Concern | System-level (`modules/work/android.nix`) | User-level (`home-manager/programs/android.nix`) |
|---|---|---|
| KVM kernel module | ✅ | – |
| `kvm` group membership | ✅ | – |
| `qemu`, `libguestfs-with-appliance`, `libvirt`, `adb` | ✅ | – |
| Android SDK (cmdline-tools, platforms, build-tools) | – | ✅ |
| Android NDK r27 | – | ✅ |
| Emulator binary + x86_64 system image | – | ✅ |
| Android Studio | – | ✅ |
| AVD creation helper (Fish) | – | ✅ |

### Files added (new)
- `modules/work/android.nix`
- `home-manager/programs/android.nix`

### Files edited (mechanical, ≤3 lines each)
- `modules/work/default.nix` — add `./android.nix` to its `imports`
- `home-manager/default.nix` — add `./programs/android.nix` to its `imports`
- `devices/lenovo-t14.nix` — add `hendrik.android = true;`

### Files explicitly untouched
`flake.nix`, `flake.lock`, `modules/base/*`, `modules/desktop/*`, `home-manager/packages/*`, `modules/work/packages.nix`, `modules/work/services.nix`, `hardware-scans/*`, all other `devices/*.nix`.

---

## 3. System-Level Module: `modules/work/android.nix`

```nix
{ config, pkgs, lib, ... }:

let
  cfg = config.hendrik.android;
in
{
  options.hendrik.android = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      When true, load the KVM kernel module, add the user to the
      `kvm` group, install qemu/libvirt/adb system-wide, and act as
      the gate for the matching home-manager Android module.
    '';
  };

  config = lib.mkIf cfg {
    # 12th-gen Intel exposes VMX; loading `kvm-intel` eagerly avoids a
    # first-emulator race where the module isn't ready in time. `tun` is
    # needed by the emulator's user-mode networking fallback on some
    # libc / kernel combinations.
    boot.kernelModules = [ "kvm-intel" "tun" ];

    # Membership in `kvm` is what lets qemu open /dev/kvm as the user
    # without setuid. Additive — `libvirtd` is added in devices/lenovo-t14.nix.
    users.users.hendrik.extraGroups = [ "kvm" ];

    environment.systemPackages = with pkgs; [
      qemu                       # qemu-kvm, qemu-img, qemu-system-x86_64
      libguestfs-with-appliance  # virt-cat, virt-ls for VM image inspection
      libvirt                    # virsh + virt-install CLIs
      adb                        # adb / fastboot on system PATH
    ];
  };
}
```

**Intentional omissions:**
- No `services.spice-vdagentd` (no remote-display workflows).
- No firewall openings (libvirt NAT handles emulator egress; user opted out of physical-device ADB so no adb-over-tcp daemon either).
- No `services.qemuGuestAgent` (we own the only guest — the emulator AVD).
- No kernel param changes — `mds=off`/etc. in `modules/base/hardware.nix` are fine for KVM.

---

## 4. User-Level Module: `home-manager/programs/android.nix`

```nix
{ config, pkgs, lib, osConfig ? { }, ... }:

let
  cfg = osConfig.hendrik.android or false;

  platform   = pkgs.buildPackages.androidenv.platforms.android-34;
  buildTools = pkgs.buildPackages.androidenv.build-tools."34.0.0";
  ndk        = pkgs.androidenv.ndk."27.0.12077973";

  # composeAndroidPackages does the sdkmanager install inside the Nix
  # sandbox at build time, so no licence-acceptance dialog or per-host
  # network fetch is needed. The result is one /nix/store derivation
  # rooted at ANDROID_HOME.
  androidEnv = pkgs.androidenv.composeAndroidPackages {
    platforms    = [ platform ];
    buildTools   = [ buildTools ];
    includeNDK   = true;
    includeNdkSysroot = false;
    includeEmulator = true;
    systemImages = [
      # `default;x86_64` keeps the licence footprint small and uses
      # the KVM-friendly x86_64 system image so /dev/kvm is used.
      pkgs.buildPackages.androidenv.system-images."system-images;android-34;default;x86_64"
    ];
    includeSources = true;
  };
in
lib.mkIf cfg {
  home.packages = [
    androidEnv              # exposes bin/ for sdkmanager, avdmanager, emulator
    androidEnv.androidsdk   # the /share/android-sdk data root (also auto-PATHed)
    pkgs.android-studio
    ndk                     # exposes bin/ for ndk-build, clang, llvm, etc.
  ];

  # Set ANDROID_HOME / ANDROID_SDK_ROOT / ANDROID_NDK_HOME so Gradle,
  # sdkmanager, avdmanager, and Android Studio all find the Nix-managed
  # install paths. home.packages already puts each derivation's bin/
  # on PATH, giving us adb, emulator, sdkmanager, avdmanager with no
  # further wiring.
  home.sessionVariables = {
    ANDROID_SDK_ROOT = "${androidEnv.androidsdk}/share/android-sdk";
    ANDROID_HOME     = "${androidEnv.androidsdk}/share/android-sdk";
    ANDROID_NDK_HOME = "${ndk}";
  };

  # AVD creation helper. AVDs are not declaratively Nix-buildable (they
  # write per-user config under ~/.android/avd/) so this provides a
  # one-shot setup, idempotent on `--force`.
  programs.fish.functions.mk-android-avd = ''
    function mk-android-avd --argument name
      if test -z "$name"
        set name pixel
      end
      avdmanager create avd \
        --name $name \
        --package "system-images;android-34;default;x86_64" \
        --device "pixel" \
        --force
      echo "AVD '$name' created. Launch with: emulator -avd $name -no-window -gpu swiftshader_indirect -no-audio"
    end
  '';
}
```

**Why the `(or false)` fallback in `cfg`** — `osConfig` is `{}` when this module is loaded outside a NixOS-system-derived home-manager configuration (e.g. pure standalone). Defaulting to `false` keeps the module loadable from `nix flake check` / repl evaluation without crashing.

**Why `pkgs.android-studio` not JetBrains Toolbox** — Studio is a single-purpose IDE for Android and matches the existing JetBrains IDE entries in `home-manager/packages/work.nix` (`intellij`, `phpstorm`, `goland`); Toolbox would pull an installer + an account-creation flow that breaks the IaC posture.

**Why `default` system image** — confirmed by user. Avoids Google Play Services licensing surface and is sufficient for app build/run cycles on the AVD.

---

## 5. Opt-In Flag Wiring

Three mechanical edits, no logic changes elsewhere.

### `devices/lenovo-t14.nix`
Add one line next to the existing `hendrik.desktop = "gnome";`:
```nix
hendrik.android = true;
```

### `modules/work/default.nix`
```diff
   imports = [
     ./packages.nix
     ./services.nix
+    ./android.nix
   ];
```

### `home-manager/default.nix`
```diff
   imports = [
     ./packages
     ./programs/git.nix
     ./programs/shell.nix
     ./programs/editors.nix
     ./programs/terminals.nix
     ./programs/files.nix
     ./programs/cliphist.nix
     ./hyprland.nix
+    ./programs/android.nix
   ];
```

No change to other devices: `syn.nix`, `ack.nix`, `handcoding.nix`, `mac.nix` do not set `hendrik.android`, so the option's default `false` keeps them inert.

---

## 6. AVD Workflow (the only non-declarative bit)

AVDs write to `~/.android/avd/` and reference an SDK by path. They cannot be Nix-store-cached, but the **system image they point to can** (it's a `/nix/store` path baked by `composeAndroidPackages`).

```bash
# One-time after first switch:
mk-android-avd pixel           # or any name

# Launch:
emulator -avd pixel \
  -no-window \
  -no-audio \
  -gpu swiftshader_indirect \
  -no-snapshot

# Sanity check from host:
adb devices
adb shell getprop ro.product.cpu.abi    # → x86_64
adb shell getprop ro.build.version.sdk  # → 34
```

**Known limitation:** deleting `~/.android/avd/` and re-running `mk-android-avd` is the canonical recovery for a corrupted AVD. We do not script this; user judgement.

---

## 7. Verification

### Pre-switch (per `AGENTS.md` standard)
```bash
nix fmt
nixos-rebuild dry-activate --flake .#lenovo
```
Both must exit 0.

### Post-switch smoke test (manual)
| # | Command | Pass criterion |
|---|---|---|
| 1 | `lsmod \| grep kvm_intel` | `kvm_intel` line present |
| 2 | `ls -l /dev/kvm` | device exists, mode `0660`, group `kvm` |
| 3 | `groups` (as hendrik) | contains `kvm libvirtd` |
| 4 | `qemu-system-x86_64 --version` | exits 0 |
| 5 | `libvirtd` status | `active (running)` |
| 6 | `ls $ANDROID_SDK_ROOT` | shows `cmdline-tools/`, `platforms/`, `build-tools/`, `ndk/`, `system-images/`, `emulator/` |
| 7 | `avdmanager list avd` | empty initially |
| 8 | `mk-android-avd pixel` | AVD appears under `~/.android/avd/` |
| 9 | `emulator -avd pixel -no-window -no-audio -gpu swiftshader_indirect -no-snapshot` (background) | AVD reaches `boot completed` within ~60 s |
| 10 | `adb shell getprop ro.product.cpu.abi ; adb shell getprop ro.build.version.sdk` | `x86_64` / `34` |
| 11 | `gradle init` + `./gradlew assembleDebug` against a tiny app | BUILD SUCCESSFUL |

### Other devices unaffected
On `syn` (or any device without `hendrik.android = true;`):
```bash
nixos-rebuild dry-activate --flake .#syn
```
must still exit 0 and emit no Android-related lines.

---

## 8. Acceptance Criteria

This spec is "done" when **all** of:
1. `nixos-rebuild dry-activate --flake .#lenovo` exits 0 with no errors.
2. `nix fmt` reports no diffs.
3. Post-switch smoke-test steps 1–10 all pass on `lenovo` with a fresh user session.
4. `nixos-rebuild dry-activate --flake .#syn` (and the other non-android hosts) is unchanged in error count.
5. A minimal `assembleDebug` build (step 11) succeeds.

---

## 9. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| `pkgs.android-studio` flags a new ELF for missing FUSE shim on NixOS | low | medium | Already handled — `pkgs.android-studio` from `nixos-unstable` ships its own launcher with bundled FUSE |
| `kvm-intel` not loadable because firmware has VT-x disabled | very low (Lenovo T14 ships with it enabled) | blocks emulator | Document `BIOS → Security → Virtualization → Intel VT-x = Enabled` in spec §10 |
| `mds=off` etc. interact badly with QEMU under sustained load | low | low (rare crash) | Already disabled in `modules/base/hardware.nix`; revisit if reproducing |
| AVD locked to /nix/store path that gets GC'd | low | AVD simply won't launch | `nix-collect-garbage` requires explicit `home = true` GC, so user-managed |
| `pkgs.androidenv` lags a needed platform / build-tools version | medium | medium | Compose set is a single place to swap individual components; full reset by deletion + `flake update` |
| Android Studio needs `temurin-bin-jdk` x86 even on aarch64-darwin | n/a here | n/a | Lenovo is x86_64-linux; not a concern |

---

## 10. Future-You Notes

- **Updating NDK / build-tools / platform**: edit the version in `home-manager/programs/android.nix`, run `nixos-rebuild switch`. Single source of truth.
- **Studio cache is ~1.5 GB** at `~/.cache/Google/AndroidStudio*/`. Worth tracking under `nix-collect-garbage --delete-older-than 30d --dry-run`-style audit, not part of GC.
- **AVD delete-and-recreate** is the canonical recovery for bitmap corruption. The `mk-android-avd --force` is idempotent.
- **Nested virt in firmware**: if an AVD refuses to launch with `KVM is not available`, check BIOS: `Security → Virtualization → Intel Virtualization Technology = Enabled` and `Security → Virtualization → Intel VT-d Feature = Enabled`.
- **AVA / integration tests** are deliberately out of scope. Adding them later belongs in a follow-up spec.

---

## Appendix A — Reasons for choosing in-tree `pkgs.androidenv` over manual cmdline-tools

- Reproducibility (single source of truth, lockfile-driven).
- No licence-acceptance dialog (build-time).
- No transitive `/nix/store/.../cmdline-tools/latest/bin/sdkmanager` PATH juggling — the composed derivation already knows the layout.
- Matches the repo's `AGENTS.md` "Infrastructure as Code: every configuration change must be declarative, reproducible, and modular."

## Appendix B — Pinned versions

| Component | Version | Source |
|---|---|---|
| Android platform | 34 (Android 14) | `pkgs.buildPackages.androidenv.platforms.android-34` |
| Build tools | 34.0.0 | `pkgs.buildPackages.androidenv.build-tools."34.0.0"` |
| NDK | r27 (27.0.12077973) | `pkgs.androidenv.ndk."27.0.12077973"` |
| System image | `system-images;android-34;default;x86_64` | `pkgs.buildPackages.androidenv.system-images.*` |
| Android Studio | latest stable in `nixos-unstable` | `pkgs.android-studio` |

These can be bumped in isolation. The spec doesn't pin to any external URL — Nixpkgs versions follow the flake input.
