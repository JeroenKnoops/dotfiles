{ config, lib, pkgs, ... }:

let
  cfg = config.programs.git.findBuild;
in
{
  options.programs.git.findBuild = {
    enable = lib.mkEnableOption "git find-build command with multi-criteria JSON note queries";

    notesRef = lib.mkOption {
      type = lib.types.str;
      default = "refs/notes/commits";
      description = "Git notes ref to search (e.g. refs/notes/commits)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    home.packages = [
      pkgs.jq
    ];

    home.sessionPath = [ "$HOME/.local/bin" ];

    home.file.".local/bin/git-find-build" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        if [ "$#" -lt 1 ]; then
          echo "Usage: git find-build key=value [key=value ...]" >&2
          echo "Example: git find-build target=qemuarm64 variant=vnv build_id addd9c90227a092fb7f1ef86a017552a67ab49ae" >&2
          exit 1
        fi

        NOTES_REF="${cfg.notesRef}"

        # Build jq filter dynamically: .target == "qemuarm64" and .variant == "vnv"
        JQ_FILTER="true"

        for arg in "$@"; do
          if [[ "$arg" != *=* ]]; then
            echo "Invalid argument: $arg (expected key=value)" >&2
            exit 1
          fi
          key="''${arg%%=*}"
          value="''${arg#*=}"
          JQ_FILTER="$JQ_FILTER and .[\"$key\"] == \"$value\""
        done

        git notes --ref "$NOTES_REF" list | awk '{print $2}' | while read -r sha; do
          git notes --ref "$NOTES_REF" show "$sha" 2>/dev/null \
            | jq -e "$JQ_FILTER" >/dev/null \
            && echo "$sha"
        done
      '';
    };

    # Ensure notes are fetched automatically
    programs.git.settings = {
      remote.origin.fetch = [
        "+refs/notes/*:refs/notes/*"
      ];
    };
  };
}
