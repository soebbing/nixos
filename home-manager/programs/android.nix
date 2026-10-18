{ config, pkgs, lib, osConfig ? { }, ... }:

let
  cfg = osConfig.hendrik.android or false;

  platform = pkgs.buildPackages.androidenv.platforms.android-34;
  buildTools = pkgs.buildPackages.androidenv.build-tools."34.0.0";
  ndk = pkgs.androidenv.ndk."27.0.12077973";

  # composeAndroidPackages does the sdkmanager install inside the Nix
  # sandbox at build time, so no licence-acceptance dialog or per-host
  # network fetch is needed. The result is one /nix/store derivation
  # rooted at ANDROID_HOME.
  androidEnv = pkgs.androidenv.composeAndroidPackages {
    platforms = [ platform ];
    buildTools = [ buildTools ];
    includeNDK = true;
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
    androidEnv # exposes bin/ for sdkmanager, avdmanager, emulator
    androidEnv.androidsdk # the /share/android-sdk data root (also auto-PATHed)
    pkgs.android-studio
    ndk # exposes bin/ for ndk-build, clang, llvm, etc.
  ];

  # Set ANDROID_HOME / ANDROID_SDK_ROOT / ANDROID_NDK_HOME so Gradle,
  # sdkmanager, avdmanager, and Android Studio all find the Nix-managed
  # install paths. home.packages already puts each derivation's bin/
  # on PATH, giving us adb, emulator, sdkmanager, avdmanager with no
  # further wiring.
  home.sessionVariables = {
    ANDROID_SDK_ROOT = "${androidEnv.androidsdk}/share/android-sdk";
    ANDROID_HOME = "${androidEnv.androidsdk}/share/android-sdk";
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
