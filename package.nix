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
    pkgs.git
    pkgs.icu          # StabilityMatrix: Couldn't find a valid ICU package installed on the system
    pkgs.libxcrypt-legacy # comfyui: libcrypt.so.1: cannot open shared object file: No such file or directory
    pkgs.uv           # forge-neo: /bin/sh: uv: command not found
    pkgs.pkg-config   # reForge: Did not find pkg-config by name 'pkg-config'
    pkgs.cmake        # reForge: cmake not found
    pkgs.gcc          # reForge: Unknown compiler(s): [['cc'], ['gcc'], ...]
    pkgs.cairo.dev    # reForge: Dependency "cairo" not found, tried pkgconfig
    pkgs.libxcb.dev   # reForge: fatal error: xcb/xcb.h: No such file or directory
    pkgs.libX11.dev   # reForge: fatal error: X11/Xlib.h: No such file or directory
    pkgs.xorgproto    # reForge: fatal error: X11/X.h: No such file or directory
    pkgs.zstd         # comfyui: libzstd.so.1: cannot open shared object file: No such file or directory
  ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
      --set APPIMAGE $out/bin/${pname}
  '';
  # Note some apps within StabilityMatrix require distutils in stdlib,
  # while others require distutils from setuptools.
  # So not setting the env variable here. But leaving it for reference
  # --set SETUPTOOLS_USE_DISTUTILS stdlib # this may fix the following error:
  # '''setuptools vendored distutils conflicts with bundled cpython-3.10.19'''
  # as it tells setuptools to not override stdlib's distutils with its own
  # But this will break any python >3.12 as stdlib no longer has distutils
  
  meta = {
    description = "Multi-platform package manager for Stable Diffusion";
    homepage = "https://github.com/LykosAI/StabilityMatrix";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
