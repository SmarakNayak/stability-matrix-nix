{ lib, appimageTools, fetchzip, makeWrapper }:

let
  pname = "stability-matrix";
  version = "2.15.6";

  src = (fetchzip {
    url = "https://github.com/LykosAI/StabilityMatrix/releases/download/v${version}/StabilityMatrix-linux-x64.zip";
    hash = "sha256-607+rH7jURBpA7AW/jIuW9WHz7x20JxWT+MGSx/MAuU=";
    stripRoot = false;
  }) + "/StabilityMatrix.AppImage";
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    pkgs.icu          # StabilityMatrix: Couldn't find a valid ICU package installed on the system
    pkgs.libxcrypt-legacy # comfyui: libcrypt.so.1: cannot open shared object file: No such file or directory
    pkgs.uv           # forge-neo: /bin/sh: uv: command not found
    pkgs.pkg-config   # reForge: Did not find pkg-config by name 'pkg-config'
    pkgs.gcc          # reForge: Unknown compiler(s): [['cc'], ['gcc'], ...]
    pkgs.cairo.dev    # reForge: Dependency "cairo" not found, tried pkgconfig
    pkgs.libxcb.dev   # reForge: fatal error: xcb/xcb.h: No such file or directory
    pkgs.libX11.dev   # reForge: fatal error: X11/Xlib.h: No such file or directory
    pkgs.xorgproto    # reForge: fatal error: X11/X.h: No such file or directory
  ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
      --set APPIMAGE $out/bin/${pname}
  '';

  meta = {
    description = "Multi-platform package manager for Stable Diffusion";
    homepage = "https://github.com/LykosAI/StabilityMatrix";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
