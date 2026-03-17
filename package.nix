{ lib, appimageTools, fetchzip, icu, libxcrypt-legacy, uv, makeWrapper }:

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
    icu
    libxcrypt-legacy
    uv
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
