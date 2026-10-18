# Android Dev + KVM on Lenovo T14 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers-extended-cc:subagent-driven-development (recommended) or superpowers-extended-cc:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reproduce the Android + KVM stack on `lenovo-t14` exactly as specified in `docs/superpowers/specs/2026-10-18-android-kvm-design.md`, in 8 tasks that each leave the workspace in a `nixos-rebuild dry-activate`–clean state.

**Architecture:** Two new modules — system-level `modules/work/android.nix` (KVM kernel module + qemu/adb system packages, gated on `hendrik.android = true`) and user-level `home-manager/programs/android.nix` (Android SDK/NDK via `pkgs.androidenv.composeAndroidPackages`, Android Studio, Fish AVD helper, gated on `osConfig.hendrik.android`). One opt-in flag in `devices/lenovo-t14.nix` makes the system testable locally while leaving `syn`, `mac`, `ack`, `handcoding`, `megatron` untouched.

**Tech Stack:** NixOS 25.05+, home-manager (from `flake.nix` input), `pkgs.androidenv.composeAndroidPackages`, `pkgs.android-studio`, `pkgs.qemu`, `pkgs.libguestfs-with-appliance`, `pkgs.libvirt`, `pkgs.adb`. Formatter is `nixpkgs-fmt` per the existing `flake.nix`.

**Spec:** `docs/superpowers/specs/2026-10-18-android-kvm-design.md`

---

## Global Constraints

These bind every task below. Treat them as non-negotiable across the whole plan.

- **Flag defaults to `false`**: `hendrik.android` is `lib.types.bool` default `false`. Every other `devices/*.nix` (syn, mac, ack, handcoding, megatron) MUST remain unaffected — verify by `nix flake show` and a second `dry-activate` against `syn` after the change.
- **Module follows `hendrik.desktop` pattern**: opt-in via a top-level attribute on the device config (mirrors `hendrik.desktop = "gnome";` in `devices/lenovo-t14.nix`).
- **System bits go in `modules/work/`**: matches the existing `work` context split. `modules/work/default.nix` is the only existing file to import the new module from.
- **User bits go in `home-manager/programs/`**: matches where every other home-manager program already lives (e.g. `programs/git.nix`, `programs/shell.nix`).
- **Pinned versions match spec Appendix B**: Android 14 (API 34), build-tools `34.0.0`, NDK `27.0.12077973`, system image `system-images;android-34;default;x86_64`.
- **Formatter**: `nix fmt` (which uses the flake's `nixpkgs-fmt`) MUST be a no-op after every committed task.
- **No edits to**: `flake.nix`, `flake.lock`, `modules/base/*`, `modules/desktop/*`, `home-manager/packages/*`, `modules/work/packages.nix`, `modules/work/services.nix`, `hardware-scans/*`, any `devices/*.nix` other than `lenovo-t14.nix`.

**User decisions (already made):**
- Full Android stack incl. emulator — not SDK-only.
- Emulator only — no physical-device ADB over USB.
- Default x86_64 system image — no Play Services / `google_apis`.
- Include Android Studio from `pkgs.android-studio` (not JetBrains Toolbox).
- AVDs created on demand via `mk-android-avd` Fish helper, not declarative.

---

### Task 1: System-level NixOS module file

**Goal:** Drop the KVM/qemu/adb module at `modules/work/android.nix` with a `hendrik.android` option that defaults to `false` and an empty (mkIf-gated) config block.

**Files:**
- Create: `modules/work/android.nix`

**Acceptance Criteria:**
- [ ] File exists at the exact path with the content below.
- [ ] `nix-instantiate --parse modules/work/android.nix` exits 0.
- [ ] No change to flake eval is required for this task (the file isn't imported yet).

**Verify:** `nix-instantiate --parse modules/work/android.nix && echo OK` → prints `OK`.

**Steps:**

- [ ] **Step 1: Write `modules/work/android.nix`** with this exact content (mirrors spec §3, verbatim — no behavioural tweaks):

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

- [ ] **Step 2: Run the parse + format gate**

Run: `nix-instantiate --parse modules/work/android.nix && nix fmt -- --check modules/work/android.nix`
Expected: parse prints nothing (exit 0); `nix fmt --check` reports no changes.

- [ ] **Step 3: Commit**

```bash
git add modules/work/android.nix
git commit -m "feat(android): add system-level KVM/qemu/adb module (gated on hendrik.android)"
```

---

### Task 2: User-level home-manager module file

**Goal:** Drop the SDK/NDK/Studio + AVD helper at `home-manager/programs/android.nix` with `lib.mkIf osConfig.hendrik.android or false` so the module loads cleanly even when `osConfig` is `{}` (e.g. standalone HM eval).

**Files:**
- Create: `home-manager/programs/android.nix`

**Acceptance Criteria:**
- [ ] File exists at the exact path with the content below.
- [ ] `nix-instantiate --parse home-manager/programs/android.nix` exits 0.
- [ ] The `osConfig ? { }` default keeps the module loadable from a standalone `home-manager build` invocation (it MUST NOT throw when `osConfig.hendrik.android` is missing).

**Verify:** `nix-instantiate --parse home-manager/programs/android.nix && nix fmt -- --check home-manager/programs/android.nix` → both exit 0.

**Steps:**

- [ ] **Step 1: Write `home-manager/programs/android.nix`** with this exact content (mirrors spec §4, including the corrected `home.sessionVariables` per self-review):

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

- [ ] **Step 2: Run the parse + format gate**

Run: `nix-instantiate --parse home-manager/programs/android.nix && nix fmt -- --check home-manager/programs/android.nix`
Expected: parse prints nothing (exit 0); `nix fmt --check` reports no changes.

- [ ] **Step 3: Commit**

```bash
git add home-manager/programs/android.nix
git commit -m "feat(android): add home-manager SDK/NDK/Studio module (gated on osConfig.hendrik.android)"
```

---

### Task 3: Wire both modules into their parent imports

**Goal:** Make the two new modules reachable from the flake without changing any conditional behavior (the flag is still default-off, so dry-activate must remain a no-op apart from the import itself).

**Files:**
- Modify: `modules/work/default.nix:1-9` — add `./android.nix` to its `imports` list
- Modify: `home-manager/default.nix:69-77` — add `./programs/android.nix` to its `imports` list

**Acceptance Criteria:**
- [ ] `modules/work/default.nix` imports `./android.nix`.
- [ ] `home-manager/default.nix` imports `./programs/android.nix`.
- [ ] `nix flake show` exits 0 — flake still evaluates.
- [ ] `nix fmt --check` is a no-op.
- [ ] `nixos-rebuild dry-activate --flake .#lenovo` exits 0 (flag defaults to `false`, so neither module activates yet — this is the safety check).

**Verify:** `nixos-rebuild dry-activate --flake .#lenovo 2>&1 | tail -20` → exits 0 with no errors. And `git grep hendrik.android devices/` shows ONLY the option declaration, not the assignment (still defaulting to `false`).

**Steps:**

- [ ] **Step 1: Edit `modules/work/default.nix`** — add `./android.nix` to the imports list:

```diff
 {
   imports = [
     ./packages.nix
     ./services.nix
+    ./android.nix
   ];
 }
```

- [ ] **Step 2: Edit `home-manager/default.nix`** — add `./programs/android.nix` to the imports list at the end:

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

- [ ] **Step 3: Run the full eval + format gate**

Run: `nix fmt && nixos-rebuild dry-activate --flake .#lenovo`
Expected: formatter reports no changes (already formatted). Dry-activate exits 0 with the same change-set as before this task. No new system modules referenced in the build plan.

- [ ] **Step 4: Confirm `syn` is still untouched**

Run: `nixos-rebuild dry-activate --flake .#syn 2>&1 | tail -5`
Expected: exits 0; no Android-related errors or warnings.

- [ ] **Step 5: Commit**

```bash
git add modules/work/default.nix home-manager/default.nix
git commit -m "feat(android): wire android.nix modules into parent imports"
```

---

### Task 4: Opt-in flag in `devices/lenovo-t14.nix`

**Goal:** Set `hendrik.android = true;` next to the existing `hendrik.desktop = "gnome";` line — this is the *only* line that flips on the system- and user-level modules for this device.

**Files:**
- Modify: `devices/lenovo-t14.nix:16` — add `hendrik.android = true;` immediately after `hendrik.desktop = "gnome";`

**Acceptance Criteria:**
- [ ] Exactly one new line: `hendrik.android = true;` appears immediately after the `hendrik.desktop` line.
- [ ] `nix flake show` exits 0.
- [ ] `nixos-rebuild dry-activate --flake .#lenovo` exits 0 (longer eval expected as it now references `pkgs.androidenv`).
- [ ] `nixos-rebuild dry-activate --flake .#syn` exits 0 with no Android material — confirms `syn` doesn't leak the flag.

**Verify:** `nix flake show 2>&1 | head` → exits 0. Then `nixos-rebuild dry-activate --flake .#lenovo` → exits 0 with the build plan mentioning `system-path` with KVM module load (`boot.kernelModules = [ "kvm-intel" "tun" ]`) in the activation script.

**Steps:**

- [ ] **Step 1: Edit `devices/lenovo-t14.nix`** — add the opt-in flag right after the existing `hendrik.desktop` line:

```diff
   hendrik.desktop = "gnome";
+
+  # Local Android dev: KVM, qemu/adb, Android SDK/NDK/Studio, AVD helper.
+  # Modules gated on this flag live in modules/work/android.nix and
+  # home-manager/programs/android.nix. False everywhere else.
+  hendrik.android = true;
```

- [ ] **Step 2: Validate the flag wiring**

Run: `nix fmt --check` (no diff expected) then `nixos-rebuild dry-activate --flake .#lenovo`
Expected: formatter clean; dry-activate exits 0 with a build plan that now lists `kvm-intel` kernel module and references `pkgs.androidenv.composeAndroidPackages`-derived derivations. Eval time longer than Task 3 (Android SDK is a big composition).

- [ ] **Step 3: Confirm `syn` is still clean**

Run: `nixos-rebuild dry-activate --flake .#syn 2>&1 | grep -i android`
Expected: empty output (no Android material) AND exit 0.

- [ ] **Step 4: Commit**

```bash
git add devices/lenovo-t14.nix
git commit -m "feat(android): opt Lenovo T14 into hendrik.android stack"
```

---

### Task 5: `nixos-rebuild switch` to land the system changes

**Goal:** Materialise the kernel module, `/dev/kvm`, the `kvm` group membership for `hendrik`, and the qemu/libvirt/adb system packages.

**Files:**
- None (this is the build/apply step).

**Acceptance Criteria:**
- [ ] `nixos-rebuild switch --flake .#lenovo` exits 0.
- [ ] After the switch, in a *new* shell, the system bits are live — KVM kernel module is loaded, the `kvm` device is owned by group `kvm` with mode `0660`, and `qemu-system-x86_64` is on `$PATH`.
- [ ] `hendrik` is in the `kvm` group (logout/login may be required; document this for Task 7).
- [ ] `nix-store -q --references /run/current-system | grep -E 'qemu|android-studio'` shows the expected derivations are reachable.
- [ ] `nix-collect-garbage` was NOT run as part of this task (deliberate — `nixos-rebuild switch` doesn't auto-gc).

**Verify:** `nixos-rebuild switch --flake .#lenovo 2>&1 | tail -5` → exits 0. Then in a fresh shell: `lsmod | grep kvm_intel` → line for `kvm_intel` present.

**Steps:**

- [ ] **Step 1: Run `nixos-rebuild switch`**

Run: `sudo nixos-rebuild switch --flake .#lenovo`
Expected: exits 0; first build can take 10–30 minutes because Android SDK + NDK + Studio + system image are all being built from the nixpkgs input. Do NOT cancel.

- [ ] **Step 2: Verify kernel module and KVM device (without relogin)**

Run:
```bash
lsmod | grep -E "kvm|tun"
ls -l /dev/kvm
qemu-system-x86_64 --version | head -1
```
Expected:
- `kvm_intel` and `tun` listed by `lsmod`.
- `/dev/kvm` exists with mode `0660`, group `kvm`.
- `qemu-system-x86_64` reports a version.

Note: `groups` will NOT yet show `kvm` — that's added by `users.users.hendrik.extraGroups`, which requires a fresh login. Task 7 verifies that.

- [ ] **Step 3: Commit nothing, this is a build step**

There is no source change in this task. The `flake.lock` may have been resolved by the build but is not touched by hand. Skip the `git commit`.

---

### Task 6: System-level smoke tests post-switch

> **USER-ORDERED GATE — NON-SKIPPABLE.** This task was requested by the user in the current conversation via the spec's `§7 Verification` and `§8 Acceptance Criteria`. It MUST NOT be closed by walking around it, by declaring it "verified inline", or by substituting a cheaper check. Close only after every acceptance criterion below has been re-validated independently, with output captured.

**Goal:** Validate that the system-level parts of the spec are actually live after `nixos-rebuild switch` — kernel module, /dev/kvm, group membership, qemu/libvirt/adb on PATH, libvirtd running.

**Files:**
- None.

**Acceptance Criteria (each MUST be observed independently; capture output to confirm):**
- [ ] AC1: `lsmod | grep kvm_intel` returns a non-empty line containing `kvm_intel`.
- [ ] AC2: `ls -l /dev/kvm` shows the device with group `kvm` and mode `0660`.
- [ ] AC3: `groups` (run as `hendrik` after fresh login) contains `kvm`.
- [ ] AC4: `qemu-system-x86_64 --version` reports a version string.
- [ ] AC5: `systemctl is-active libvirtd` returns `active`.

**Verify:** Run the smoke-test block below; each command's output MUST match the expected line literally.

```bash
# Block 1 — kernel + device
lsmod | grep -q kvm_intel && echo "AC1 PASS" || echo "AC1 FAIL"
ls -l /dev/kvm | grep -q "crw-rw----.*kvm" && echo "AC2 PASS" || echo "AC2 FAIL"

# Block 2 — group and tools (after relogin so /run/user/<uid>/supplementary groups pick up `kvm`)
groups | grep -q "\bkvm\b" && echo "AC3 PASS" || echo "AC3 FAIL"

# Block 3 — qemu + libvirt
qemu-system-x86_64 --version | head -1
systemctl is-active libvirtd
```

**Steps:**

- [ ] **Step 1: Re-login or `newgrp kvm` for the group change to take effect**

Run: `newgrp kvm`
Expected: shell starts a subshell in which `groups` includes `kvm`. This is the only way to test AC3 without a full graphical logout/login.

- [ ] **Step 2: Run AC1 + AC2 verification**

Run: `lsmod | grep -q kvm_intel && ls -l /dev/kvm | grep -q "crw-rw----.*kvm"`
Expected: exit 0.

- [ ] **Step 3: Run AC3 verification**

Run: `groups | grep -q "\bkvm\b"`
Expected: exit 0 (after `newgrp`).

- [ ] **Step 4: Run AC4 + AC5 verification**

Run: `qemu-system-x86_64 --version | head -1 ; systemctl is-active libvirtd`
Expected: a version string, then `active` on the next line.

- [ ] **Step 5: Capture output to a verification log**

Run:
```bash
mkdir -p /tmp/android-verify
{
  echo "===== AC1 lsmod ====="
  lsmod | grep kvm_intel
  echo "===== AC2 /dev/kvm ====="
  ls -l /dev/kvm
  echo "===== AC3 groups ====="
  groups
  echo "===== AC4 qemu ====="
  qemu-system-x86_64 --version | head -1
  echo "===== AC5 libvirtd ====="
  systemctl is-active libvirtd
} | tee /tmp/android-verify/system.txt
```
Expected: file contains all five sections with output, exit 0.

- [ ] **Step 6: Commit the verification log (optional but recommended)**

```bash
git add -f /tmp/android-verify/system.txt 2>/dev/null || true
git diff --cached --quiet || git commit -m "test(android): capture post-switch system smoke output"
```

---

### Task 7: User-level environment ready + AVD helper functional

> **USER-ORDERED GATE — NON-SKIPPABLE.** This task was requested by the user in the current conversation via the spec's `§6 AVD Workflow` and `§7 Verification`. It MUST NOT be closed by walking around it, by declaring it "verified inline", or by substituting a cheaper check. Close only after every acceptance criterion below has been re-validated independently, with output captured.

**Goal:** Confirm the SDK/NDK/Studio + AVD helper are present, and exercise the helper to create the first AVD.

**Files:**
- None (but the helper's existence implies Task 2's module loaded correctly).

**Acceptance Criteria (each observed independently):**
- [ ] UB1: `echo $ANDROID_SDK_ROOT` is non-empty and points inside `/nix/store`.
- [ ] UB2: `echo $ANDROID_NDK_HOME` is non-empty and points inside `/nix/store`.
- [ ] UB3: `ls $ANDROID_SDK_ROOT` contains `cmdline-tools`, `platforms`, `build-tools`, `ndk`, `system-images`, `emulator`.
- [ ] UB4: `which adb` resolves to a path; `adb version` reports a recent version.
- [ ] UB5: `which avdmanager` resolves to a path under `$ANDROID_SDK_ROOT/cmdline-tools/.../bin`.
- [ ] UB6: `type mk-android-avd` shows the function is defined in the user shell.
- [ ] UB7: `mk-android-avd smoketest` creates an AVD. `avdmanager list avd | grep smoketest` shows it.
- [ ] UB8: `ls $HOME/.android/avd/smoketest.ini` exists.
- [ ] UB9: `nix-env -q` (or `nix profile list` on 25.05+) shows `android-studio` and the SDK derivation referenced from the user profile.

**Verify:** Run the smoke-test block below; each line MUST succeed.

```bash
set -e
echo "=== UB1 SDK_ROOT ===" ; echo "$ANDROID_SDK_ROOT" | grep -q "/nix/store" && echo OK
echo "=== UB2 NDK_HOME ===" ; echo "$ANDROID_NDK_HOME" | grep -q "/nix/store" && echo OK
echo "=== UB3 SDK layout ===" ; for d in cmdline-tools platforms build-tools ndk system-images emulator; do test -e "$ANDROID_SDK_ROOT/$d" && echo "$d OK" || echo "$d FAIL"; done
echo "=== UB4 adb ===" ; adb version | head -1
echo "=== UB5 avdmanager ===" ; which avdmanager
echo "=== UB6 mk-android-avd ===" ; type mk-android-avd
echo "=== UB7 create AVD ===" ; mk-android-avd smoketest
echo "=== UB8 AVD ini ===" ; ls -l $HOME/.android/avd/smoketest.ini
echo "=== UB9 AVD listed ===" ; avdmanager list avd | grep smoketest
```

**Steps:**

- [ ] **Step 1: Open a fresh Fish login shell**

Fish reads `home-manager/programs/android.nix`'s `programs.fish.functions` and `home.sessionVariables` only on a fresh login shell. Existing shells won't pick them up.

Run: `exec fish -l`
Expected: prompt returns.

- [ ] **Step 2: Run UB1–UB5 verification**

Run the `echo` and `which` / `adb version` / `ls` checks from the `Verify` block above.
Expected: all four print `OK`, a recent `adb version`, and an `avdmanager` path under the SDK.

- [ ] **Step 3: Run UB6 verification**

Run: `type mk-android-avd`
Expected: prints the function body declared in `programs/fish.functions.mk-android-avd`.

- [ ] **Step 4: Run UB7–UB8: create an AVD**

Run: `mk-android-avd smoketest`
Expected: prints `AVD 'smoketest' created. Launch with: …` AND exits 0.

Then: `ls -l $HOME/.android/avd/smoketest.ini`
Expected: file exists, owned by `hendrik`.

- [ ] **Step 5: Run UB9: AVD appears in `avdmanager list avd`**

Run: `avdmanager list avd | grep smoketest`
Expected: line containing `Name: smoketest` (or similar label output by avdmanager).

- [ ] **Step 6: Capture output to the verification log**

Run:
```bash
{
  echo "===== UB1 UB2 envs ====="
  echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"
  echo "ANDROID_NDK_HOME=$ANDROID_NDK_HOME"
  echo "===== UB3 SDK layout ====="
  ls $ANDROID_SDK_ROOT
  echo "===== UB4 adb ====="
  adb version | head -1
  echo "===== UB5 avdmanager ====="
  which avdmanager
  echo "===== UB6 mk-android-avd type ====="
  type mk-android-avd
  echo "===== UB7 UB8 UB9 AVD ====="
  ls -l $HOME/.android/avd/
  avdmanager list avd
} | tee /tmp/android-verify/user.txt
```
Expected: file written, exit 0.

---

### Task 8: Emulator smoke test + minimal `assembleDebug`

> **USER-ORDERED GATE — NON-SKIPPABLE.** This task was requested by the user in the current conversation via the spec's `§6 AVD Workflow` and `§7 Verification`. It MUST NOT be closed by walking around it, by declaring it "verified inline", or by substituting a cheaper check. Close only after every acceptance criterion below has been re-validated independently, with output captured.

**Goal:** Boot the headless emulator against the AVD from Task 7, verify `adb` sees it, run `getprop` to confirm x86_64 + API 34, and finish with a minimal `gradle assembleDebug` to round out the build path.

**Files:**
- None.

**Acceptance Criteria (each observed independently):**
- [ ] EM1: `emulator -avd smoketest -no-window -no-audio -gpu swiftshader_indirect -no-snapshot` boots an AVD. Within ~90 seconds `adb devices` lists `emulator-5554` as `device`.
- [ ] EM2: `adb -s emulator-5554 shell getprop ro.product.cpu.abi` → `x86_64`.
- [ ] EM3: `adb -s emulator-5554 shell getprop ro.build.version.sdk` → `34`.
- [ ] EM4: `adb -s emulator-5554 shell getprop sys.boot_completed` → `1`.
- [ ] EM5: a transient Gradle project created in `$(mktemp -d)` builds a debug APK. `./gradlew assembleDebug` exits 0.

**Verify:** Run the smoke-test block below; each command MUST succeed.

```bash
set -e
TMP=$(mktemp -d)
# Boot AVD in background, capture log
emulator -avd smoketest -no-window -no-audio -gpu swiftshader_indirect -no-snapshot \
  > "$TMP/emu.log" 2>&1 &
EMU_PID=$!

# Wait up to 90s for adb to see the device
for i in $(seq 1 90); do
  state=$(adb -s emulator-5554 get-state 2>/dev/null || echo unknown)
  if [ "$state" = "device" ]; then break; fi
  sleep 1
done

echo "=== EM1 adb devices ==="
adb devices

echo "=== EM2 EM3 EM4 properties ==="
adb -s emulator-5554 shell getprop ro.product.cpu.abi
adb -s emulator-5554 shell getprop ro.build.version.sdk
adb -s emulator-5554 shell getprop sys.boot_completed

# Optional EM5: minimal Gradle build
cd "$TMP" && gradle init --type basic --dsl kotlin --project-name smoke --no-split-project \
  >/dev/null 2>&1 || true
cd "$TMP"
[ -f settings.gradle.kts ] || mv settings.gradle settings.gradle.kts 2>/dev/null || true
echo "=== EM5 gradle assembleDebug ==="
( ./gradlew assembleDebug --no-daemon --console=plain ) || echo "GRADLE_BUILD_FAILED"

# Cleanup
adb -s emulator-5554 emu kill || true
wait $EMU_PID 2>/dev/null || true
```

**Steps:**

- [ ] **Step 1: Launch the headless emulator in the background**

Run:
```bash
TMP=$(mktemp -d)
emulator -avd smoketest -no-window -no-audio -gpu swiftshader_indirect -no-snapshot \
  > "$TMP/emu.log" 2>&1 &
EMU_PID=$!
echo "Emulator PID=$EMU_PID, log=$TMP/emu.log"
```
Expected: command returns immediately with the PID; do NOT wait inline.

- [ ] **Step 2: Wait up to 90 seconds for `adb devices` to show `device` state**

Run:
```bash
for i in $(seq 1 90); do
  state=$(adb -s emulator-5554 get-state 2>/dev/null || echo unknown)
  if [ "$state" = "device" ]; then echo "ready after ${i}s"; break; fi
  sleep 1
done
adb devices
```
Expected: prints `ready after Ns` (N under 90), then `adb devices` shows `emulator-5554  device`.

If the loop times out without state=device, capture `cat "$TMP/emu.log"` for diagnosis; do NOT mark this task complete.

- [ ] **Step 3: Run EM2 + EM3 + EM4 verification**

Run:
```bash
adb -s emulator-5554 shell getprop ro.product.cpu.abi
adb -s emulator-5554 shell getprop ro.build.version.sdk
adb -s emulator-5554 shell getprop sys.boot_completed
```
Expected: `x86_64`, `34`, `1` respectively.

- [ ] **Step 4: Optional EM5: minimal `gradle assembleDebug`**

The spec marks EM5 as "Optional but recommended". Run if a network connection to fetch Gradle wrapper is available.

Run:
```bash
TMP=$(mktemp -d)
cd "$TMP"
gradle init --type basic --dsl kotlin --project-name smoke --no-split-project
./gradlew assembleDebug --no-daemon --console=plain 2>&1 | tail -20
```
Expected (if network is reachable): first run downloads the Gradle wrapper, then `BUILD SUCCESSFUL`. If offline, capture the failure and mark EM5 as `deferred (offline)`.

- [ ] **Step 5: Tear down the emulator**

Run:
```bash
adb -s emulator-5554 emu kill || true
```
Expected: emulator exits cleanly within ~5 seconds.

- [ ] **Step 6: Capture output to the verification log**

Run:
```bash
{
  echo "===== EM1 adb devices (after wait) ====="
  adb devices
  echo "===== EM2 EM3 EM4 getprop ====="
  adb -s emulator-5554 shell getprop ro.product.cpu.abi
  adb -s emulator-5554 shell getprop ro.build.version.sdk
  adb -s emulator-5554 shell getprop sys.boot_completed || true
  echo "===== EM5 gradle output (tail) ====="
  # Last 20 lines of the gradle log if Step 4 was attempted
} | tee /tmp/android-verify/emulator.txt
```
Expected: file written, exit 0.

- [ ] **Step 7: Final commit (verification log + any spec-mandated cleanup)**

```bash
git add -f /tmp/android-verify/emulator.txt 2>/dev/null || true
git diff --cached --quiet || \
  git commit -m "test(android): emulator + gradle smoke-test verification log"
```

---

## Done = All 8 tasks complete

The spec's `§8 Acceptance Criteria` is satisfied once Tasks 5–8 have run with all acceptance criteria PASS and the verification logs at `/tmp/android-verify/{system,user,emulator}.txt` exist. If any AC in Tasks 6–8 fails, do **not** continue — return to the responsible task and fix the root cause first.
