{
  # Work in progress MPD service
  services.mpd = {
    enable = true;
    network.listenAddress = "0.0.0.0";
    extraConfig = ''
	audio_output {
	    #type "alsa"
	    #name "MPD alsa"
	    type "pulse"
	    name "MPD pulse"
	}
    '';
  };
}
