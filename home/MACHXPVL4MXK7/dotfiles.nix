
{ inputs, ... }:
{
  home.file.".config/nvim" = {
    source  = "${inputs.dotfiles}/nvim";
    recursive = true;
  };
  home.file.".ssh/allowed_signers".text = ''
    jeroen.knoops@philips.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6uhyzK5oy4CHVGAadwbop1m2hOIQZWLuTqvLXG3PY+
  '';
}
