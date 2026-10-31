{ pkgs, ... }:

let
  pinta-launcher = pkgs.writeShellApplication {
    name = "pinta-jailed";

    runtimeInputs = [
      pkgs.bubblewrap
      pkgs.coreutils
    ];

    text = ''
      pictures_dir="$HOME/Pictures"
      sandbox_root="''${XDG_DATA_HOME:-$HOME/.local/share}/pinta-sandbox"
      runtime_dir="''${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}"
      wayland_display="''${WAYLAND_DISPLAY:-wayland-0}"
      wayland_socket="$runtime_dir/$wayland_display"

      if [[ ! -d "$pictures_dir" ]]; then
        echo "Pinta sandbox: $pictures_dir does not exist" >&2
        exit 1
      fi

      if [[ ! -S "$wayland_socket" ]]; then
        echo "Pinta sandbox: Wayland socket not found: $wayland_socket" >&2
        exit 1
      fi

      mkdir -p \
        "$sandbox_root/config" \
        "$sandbox_root/cache" \
        "$sandbox_root/data"

      exec bwrap \
        --die-with-parent \
        --new-session \
        --unshare-all \
        --ro-bind /nix /nix \
        --ro-bind-try /etc/fonts /etc/fonts \
        --ro-bind-try /etc/localtime /etc/localtime \
        --ro-bind-try /run/current-system /run/current-system \
        --ro-bind-try /run/opengl-driver /run/opengl-driver \
        --proc /proc \
        --dev /dev \
        --dev-bind-try /dev/dri /dev/dri \
        --tmpfs /tmp \
        --dir "$HOME" \
        --dir "$HOME/Pictures" \
        --dir "$HOME/.config" \
        --dir "$HOME/.cache" \
        --dir "$HOME/.local" \
        --dir "$HOME/.local/share" \
        --bind "$pictures_dir" "$HOME/Pictures" \
        --bind "$sandbox_root/config" "$HOME/.config" \
        --bind "$sandbox_root/cache" "$HOME/.cache" \
        --bind "$sandbox_root/data" "$HOME/.local/share" \
        --dir "$runtime_dir" \
        --ro-bind "$wayland_socket" "$wayland_socket" \
        --setenv HOME "$HOME" \
        --setenv XDG_CONFIG_HOME "$HOME/.config" \
        --setenv XDG_CACHE_HOME "$HOME/.cache" \
        --setenv XDG_DATA_HOME "$HOME/.local/share" \
        --setenv XDG_RUNTIME_DIR "$runtime_dir" \
        --setenv WAYLAND_DISPLAY "$wayland_display" \
        --setenv GDK_BACKEND wayland \
        --setenv NO_AT_BRIDGE 1 \
        ${pkgs.pinta}/bin/pinta "$@"
    '';
  };

  pinta-icons = pkgs.runCommand "pinta-icons" { } ''
    mkdir -p "$out/share"

    if [[ -d ${pkgs.pinta}/share/icons ]]; then
      cp -r ${pkgs.pinta}/share/icons "$out/share/icons"
    fi
  '';

  pinta-jailed = pkgs.symlinkJoin {
    name = "pinta-jailed";
    paths = [
      pinta-launcher
      pinta-icons
    ];
  };
in
{
  home.packages = [
    pinta-jailed
  ];

  xdg.desktopEntries.pinta-jailed = {
    name = "Pinta (Sandboxed)";
    genericName = "Image Editor";
    comment = "Edit images in an isolated sandbox";
    exec = "${pinta-jailed}/bin/pinta-jailed %F";
    icon = "pinta";
    terminal = false;

    categories = [
      "Graphics"
      "2DGraphics"
      "RasterGraphics"
      "GTK"
    ];

    mimeType = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/tiff"
    ];
  };
}
