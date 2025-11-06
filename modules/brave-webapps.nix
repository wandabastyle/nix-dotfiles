{ config, lib, pkgs, ... }:

let
  brave = lib.getExe pkgs.brave; # uses the Brave you already install elsewhere
  dataDir = "${config.home.homeDirectory}/.local/share/brave-webapps";
in
{
  xdg.desktopEntries = {
    twitch-webapp = {
      name = "Twitch";
      comment = "Twitch in a standalone Brave window";
      exec = "${brave} --app=https://www.twitch.tv --user-data-dir=${dataDir}/twitch --class=TwitchWebApp";
      terminal = false;
      categories = [ "Network" "AudioVideo" ];
      startupWMClass = "TwitchWebApp";
      # icon = "twitch" # or a full path to your icon
    };

    youtube-webapp = {
      name = "YouTube";
      comment = "YouTube in a standalone Brave window";
      exec = "${brave} --app=https://www.youtube.com --user-data-dir=${dataDir}/youtube --class=YouTubeWebApp";
      terminal = false;
      categories = [ "Network" "AudioVideo" ];
      startupWMClass = "YouTubeWebApp";
      # icon = "youtube"
    };
  };
}
