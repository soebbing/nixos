{ config, pkgs, lib, osConfig ? { }, ... }:

let
  cfg = osConfig.hendrik.android or false;

  # composeAndroidPackages does the sdkmanager install inside the Nix
  # sandbox at build time, so no licence-acceptance dialog or per-host
  # network fetch is needed. The result is one /nix/store derivation
  # rooted at ANDROID_HOME. We pass version strings (not pre-resolved
  # pkgs) so the function can resolve everything from the Android repo
  # bundled in the nixpkgs input. The shape of this call mirrors
  # compose-android-packages.nix lines 31-162 (nixpkgs pinned in flake.lock).
  androidEnv = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
    buildToolsVersions = [ "34.0.0" ];
    ndkVersions = [ "27.0.12077973" ];
    includeNDK = true;
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "default" ];
    abiVersions = [ "x86_64" ];
    includeSources = true;
  };
in
lib.mkIf cfg {
  home.packages = [
    androidEnv # exposes bin/ for sdkmanager, avdmanager, emulator
    androidEnv.androidsdk # the /libexec/android-sdk data root (also auto-PATHed)
    pkgs.android-studio
  ];

  # ANDROID_HOME / ANDROID_SDK_ROOT point at the SDK layout that
  # cmdline-tools.nix builds at $androidsdk/libexec/android-sdk. NDK
  # is symlinked into that layout under ndk/<revision>/ by
  # linkNdkPlugins (rootName = "ndk"); for r27 the revision is the
  # input string "27.0.12077973", so ANDROID_NDK_HOME points inside
  # the same SDK root. home.packages already puts each derivation's
  # bin/ on PATH, giving us adb, emulator, sdkmanager, avdmanager
  # with no further wiring.
  home.sessionVariables = {
    ANDROID_SDK_ROOT = "${androidEnv.androidsdk}/libexec/android-sdk";
    ANDROID_HOME = "${androidEnv.androidsdk}/libexec/android-sdk";
    ANDROID_NDK_HOME = "${androidEnv.androidsdk}/libexec/android-sdk/ndk/27.0.12077973";
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
