self: super: {
  dotnet3-sdk = super.dotnet-sdk.overrideAttrs (oldAttrs: {
    version = "3.1.300";
    netCoreVersion = "3.1.4";
    pname = "dotnet-sdk";

    src = super.fetchurl {
      url =
        "https://download.visualstudio.microsoft.com/download/pr/0c795076-b679-457e-8267-f9dd20a8ca28/02446ea777b6f5a5478cd3244d8ed65b/dotnet-sdk-3.1.300-linux-x64.tar.gz";
      sha512 =
        "1c3844ea5f8847d92372dae67529ebb08f09999cac0aa10ace571c63a9bfb615adbf8b9d5cebb2f960b0a81f6a5fba7d80edb69b195b77c2c7cca174cbc2fd0b";
    };
  });
}