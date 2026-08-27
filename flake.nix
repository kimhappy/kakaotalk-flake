{
  outputs =
    { ... }:
    {
      overlays.default =
        final: _:
        let
          desktopItem = final.makeDesktopItem {
            name = "kakaotalk";
            desktopName = "KakaoTalk";
            exec = "kakaotalk %u";
            icon = "kakaotalk";
            terminal = false;
            startupNotify = true;
          };

          runtimePackages = [
            (final.wineWow64Packages.stable.override { waylandSupport = true; })
            final.winetricks
            final.coreutils
            final.findutils
            final.glib
            final.gnugrep
            final.procps
          ];
        in
        {
          kakaotalk = final.stdenvNoCC.mkDerivation {
            pname = "kakaotalk";
            version = "0.1.0";

            src = final.lib.fileset.toSource {
              root = ./.;
              fileset = final.lib.fileset.unions [
                ./kakaotalk
                ./kakaotalk.png
                ./KakaoTalk_Setup.exe
              ];
            };

            strictDeps = true;
            dontConfigure = true;
            dontBuild = true;

            nativeBuildInputs = [
              final.makeWrapper
            ];

            buildInputs = [
              final.bashNonInteractive
            ];

            installPhase = ''
              runHook preInstall

              install -Dm0755 kakaotalk "$out/bin/kakaotalk"
              install -Dm0644 KakaoTalk_Setup.exe "$out/share/kakaotalk/KakaoTalk_Setup.exe"
              install -Dm0644 kakaotalk.png "$out/share/icons/hicolor/256x256/apps/kakaotalk.png"
              install -Dm0644 ${desktopItem}/share/applications/kakaotalk.desktop \
                "$out/share/applications/kakaotalk.desktop"

              substituteInPlace "$out/share/applications/kakaotalk.desktop" \
                --replace-fail 'Exec=kakaotalk %u' "Exec=$out/bin/kakaotalk %u"

              runHook postInstall
            '';

            postFixup = ''
              wrapProgram "$out/bin/kakaotalk" \
                --prefix PATH : "${final.lib.makeBinPath runtimePackages}" \
                --set-default KAKAOTALK_SETUP_EXE "$out/share/kakaotalk/KakaoTalk_Setup.exe" \
                --set KAKAOTALK_DESKTOP_FILE "$out/share/applications/kakaotalk.desktop"
            '';

            meta = {
              description = "KakaoTalk messenger, running under Wine";
              homepage = "https://www.kakaocorp.com/page/service/service/KakaoTalk";
              license = final.lib.licenses.unfree // {
                shortName = "kakaotalk";
                fullName = "KakaoTalk Terms of Service";
                url = "https://www.kakaocorp.com/page/service/terms/KakaoTalk";
              };
              sourceProvenance = [ final.lib.sourceTypes.binaryNativeCode ];
              mainProgram = "kakaotalk";
              platforms = [ "x86_64-linux" ];
            };
          };
        };
    };
}
