{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:

let
  pname = "materialious";
  version = "1.18.8";

  src = fetchurl {
    url = "https://github.com/Materialious/Materialious/releases/download/${version}/Materialious-linux-x86_64.AppImage";
    hash = "sha256-Ka27QUVRgfZBYFAVOMAWkbI0mgGMNjhp8xp3rZ3I6JQ=";
  };

  extracted = appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Materialious";
    comment = "Material Design YouTube client";
    exec = pname;
    icon = pname;
    categories = [
      "AudioVideo"
      "Video"
    ];
    terminal = false;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    install -Dm644 \
      ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    install -Dm644 \
      ${extracted}/usr/share/icons/hicolor/512x512/apps/materialious.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
  '';

  meta = {
    description = "Material Design YouTube client";
    homepage = "https://github.com/Materialious/Materialious";
    platforms = [ "x86_64-linux" ];
  };
}
