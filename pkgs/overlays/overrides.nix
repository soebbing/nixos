self: super: {
  dotnet3-sdk = super.dotnet-sdk.overrideAttrs (oldAttrs: {
    version = "3.1.401";
    netCoreVersion = "3.1.7";
    pname = "dotnet-sdk";

    src = super.fetchurl {
      url =
        "https://download.visualstudio.microsoft.com/download/pr/4f9b8a64-5e09-456c-a087-527cfc8b4cd2/15e14ec06eab947432de139f172f7a98/dotnet-sdk-3.1.401-linux-x64.tar.gz";
      sha512 =
        "5498add9ef83da44d8f7806ca1ce335ad4193c0d3181a5abda4b65e116c7331aac37a229817ff148e4487e9734ad2438f102a0eef0049e26773a185ceb78aac4";
    };
  });
}