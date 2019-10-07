self: super:

{
  # Custom packages
  swdc = super.callPackage ../custom/swdc.nix { };
  go-github-to-jira =
    super.callPackage ../custom/go-github-to-jira/default.nix { };
  imgproxy = super.callPackage ../custom/imgproxy.nix { };
  frp = super.callPackage ../custom/frp.nix { };
  wrangler = super.callPackage ../custom/wrangler.nix { };
}
