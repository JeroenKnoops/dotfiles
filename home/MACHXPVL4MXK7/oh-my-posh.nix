{ config, lib, pkgs, ...}: {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = lib.importJSON ./custom.omp.json;
  };
}
