self: super: {
  dotnet3-sdk = super.dotnet-sdk.overrideAttrs (oldAttrs: {
    version = "3.1.403";
    netCoreVersion = "3.1.9";
    pname = "dotnet-sdk";

    src = super.fetchurl {
      url =
        "https://download.visualstudio.microsoft.com/download/pr/fdd9ecec-56b4-40f4-b762-d7efe24fc3cd/ffef51844c92afa6714528e10609a30f/dotnet-sdk-3.1.403-linux-x64.tar.gz";
      sha512 =
        "0a0319ee8e9042bf04b6e83211c2d6e44e40e604bff0a133ba0d246d08bff76ebd88918ab5e10e6f7f0d2b504ddeb65c0108c6539bc4fbc4f09e4af3937e88ea";
    };
  });
}