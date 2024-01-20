default:
	rm -rf bocce.pdx
	#pdc --skip-unknown src bocce
	pdc src bocce

images:
	# TODO, make this smart
	#for file in ./src/images/*.aseprite ; do \
		#png_file = ${$$file,aseprite,png} ;\
	#done
	aseprite -b assets/images/player-small.aseprite --save-as src/images/player-small.png
	aseprite -b assets/images/other-player-small.aseprite --save-as src/images/other-player-small.png
	aseprite -b assets/images/player.aseprite --save-as src/images/player.png
	aseprite -b assets/images/player.aseprite --save-as src/images/player.png
	aseprite -b --layer "Position Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-position-phase.png
	aseprite -b --layer "Direction Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-direction-phase.png
	aseprite -b --layer "Power Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-power-phase.png
	aseprite -b --layer "Spin Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-spin-phase.png
