self: super: {
  dotnet3-sdk = super.dotnet-sdk.overrideAttrs (oldAttrs: {
    version = "3.1.402";
    netCoreVersion = "3.1.8";
    pname = "dotnet-sdk";

    src = super.fetchurl {
      url =
        "https://download.visualstudio.microsoft.com/download/pr/f01e3d97-c1c3-4635-bc77-0c893be36820/6ec6acabc22468c6cc68b61625b14a7d/dotnet-sdk-3.1.402-linux-x64.tar.gz";
      sha512 =
        "42154efb5ad66ae3dcc300b2c0573a9537dd916fc48cbae92885a63a0b6d7f7c3a4366ca2298107783bc1f1913328f35e778dcda378da276cff3b8269495d5be";
    };
  });
}