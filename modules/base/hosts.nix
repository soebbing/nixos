{ config, pkgs, ... }:

# Shared development hosts that should resolve to localhost on every machine.
# Device-specific project hosts are added in each devices/*.nix file; the two
# lists merge automatically under networking.hosts.
{
  networking.hosts."127.0.0.1" = [
    "www.canastapp.example"
    "www.unixtimestamp.example"
    "www.convert-unix-timestamp.example"
    "www.download-handbuch.example"
    "www.manuals-online.example"
    "www.djplaymysong.example"
    "www.auctionmap.example"
    "www.farbuhr.example"
    "www.utf8-encode.example"
    "www.utf8-decode.example"
  ];
}
