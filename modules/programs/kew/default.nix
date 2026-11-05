{ self, ... }:
{
  flake.nixosModules.kew =
    { pkgs, ... }:
    let
      config = pkgs.writeText "kewrc" ''
        [miscellaneous]
        path=~/Music
        useArtistsDb=1
        allowNotifications=1
        stripTrackNumbers=1
        hideLogo=0
        hideHelp=0
        hideFooter=0
        hideTimeStatus=0
        simpleTimeStatus=1
        hideSideCover=0
        collapseTopLevel=0
        autoResume=0
        titleDelay=1
        quitOnStop=0
        clearListClearsAll=1
        hideGlimmeringText=0
        replayGainCheckFirst=3
        saveRepeatShuffleSettings=0
        repeatState=0
        shuffleEnabled=0
        trackTitleAsWindowTitle=1

        [colors]
        theme=
        colorMode=3

        [crossfade]
        alwaysCrossfade=0
        fadeEnterSongMs=0
        fadeQuickMs=3000
        fadeMediumMs=5000
        fadeSlowMs=10000

        [track cover]
        coverEnabled=1
        coverAnsi=0
        coverStyle=auto

        [mouse]
        mouseEnabled=1

        [discord]
        discordRPCEnabled=0

        [chroma]
        chromaPath=
        chromaDevice=

        [visualizer]
        visualizerColorType=3
        visualizerHeight=6
        visualizerBrailleMode=0
        visualizerBarWidth=2

        [progress bar]
        progressBarElapsedEvenChar=━
        progressBarElapsedOddChar=━
        progressBarApproachingEvenChar=━
        progressBarApproachingOddChar=━
        progressBarCurrentEvenChar=━
        progressBarCurrentOddChar=━

        [key bindings]
        bind = Space, playPause
        bind = Shift+Tab, prevView
        bind = Tab, nextView
        bind = +, volUp, +5%
        bind = =, volUp, +5%
        bind = -, volDown, -5%
        bind = h, prevSong
        bind = l, nextSong
        bind = k, scrollUp
        bind = j, scrollDown
        bind = p, playPause
        bind = n, toggleNotifications
        bind = z, toggleCrossfade
        bind = v, toggleVisualizer
        bind = b, toggleAscii
        bind = r, toggleRepeat
        bind = i, cycleColorMode
        bind = t, cycleThemes
        bind = c, cycleVisualization
        bind = s, shuffle
        bind = a, seekBack
        bind = d, seekForward
        bind = o, sortLibrary
        bind = m, showLyricsPage
        bind = Shift+s, stop
        bind = x, exportPlaylist
        bind = ., addToFavorites_playlist
        bind = u, updateLibrary
        bind = f, moveSongUp
        bind = g, moveSongDown
        bind = Enter, enqueue
        bind = Backspace, clearPlaylist
        bind = Ctrl+g, enqueueAndPlay
        bind = Alt+Enter, enqueueAndPlay
        bind = Left Arrow, prevSong
        bind = Right Arrow, nextSong
        bind = Up Arrow, scrollUp
        bind = Down Arrow, scrollDown
        bind = F2, showPlaylist
        bind = F3, showLibrary
        bind = F4, showTrack
        bind = F5, showSearch
        bind = F6, showHelp
        bind = Shift+d, crossfadequick
        bind = Shift+f, crossfademedium
        bind = Shift+g, crossfadeslow
        bind = PgDn, nextPage
        bind = PgUp, prevPage
        bind = Del, remove
        bind = mouseLeft, enqueue
        bind = mouseMiddle, enqueueAndPlay
        bind = mouseRight, playPause
        bind = mouseWheelDown, scrollDown
        bind = mouseWheelUp, scrollUp
        bind = q, quit
        bind = Esc, quit
        bind = Unknown, MSG_NONE
      '';

      kewWrapper = pkgs.writeShellApplication {
        name = "kew";

        runtimeInputs = [
          pkgs.kew
        ];

        text = ''
          mkdir -p "$HOME/.config/kew"
          if [ ! -e "$HOME/.config/kew/kewrc" ]; then
            cp ${config} "$HOME/.config/kew/kewrc"
          fi

          exec ${pkgs.kew}/bin/kew "$@"
        '';
      };
    in
    {
      environment.systemPackages = [
        kewWrapper
      ];
    };
}
