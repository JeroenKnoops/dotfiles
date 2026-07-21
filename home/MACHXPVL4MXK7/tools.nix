{ lib, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  kas-changes = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-build-analyse?dir=kas-changes&rev=d4864aac6af04b0209de16bc3117e2b2bd0e76cc";
  binary-table = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-build-analyse?dir=binary-table&rev=446faf6c237c2636814e67fc670bee20f6d98e08";
  group-git-logs = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-build-analyse?dir=group-git-logs&rev=f6aaeefb6f082a5186d82e2c287f295be4aedb3a";
  dot-analyse-rs = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-dotfile?rev=87677d758e4873d5151efaccdc111b9c5f308a38";
  github-uses = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-build-analyse?dir=workflow-overview&rev=a9e8eff559f11eb0615485d0cecd24d1dc3bd2e6";
  tag-prs = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-build-analyse?dir=tag-prs&rev=94b562e526c8400cb2680e926658e85e18f26ff4";
  pn-buildlist-tool = builtins.getFlake "git+ssh://git@github.com/philips-internal/synergy-build-analyse?dir=pn-buildlist-tool&rev=29f721b3602e0a51788ff6c7bfd258fe7c22e910";
in
{
  home.packages = [
    kas-changes.packages.${system}.default
    binary-table.packages.${system}.default
    group-git-logs.packages.${system}.default
    dot-analyse-rs.packages.${system}.recipe-grep
    dot-analyse-rs.packages.${system}.recipe-neighbour
    github-uses.packages.${system}.default
    tag-prs.packages.${system}.default
    pn-buildlist-tool.packages.${system}.default
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libiconv
  ];
}
