default:
	rm -rf bocce.pdx
	pdc --skip-unknown src bocce

images:
	# TODO, make this smart
	#for file in ./src/images/*.aseprite ; do \
		#png_file = ${$$file,aseprite,png} ;\
	#done
	aseprite -b assets/images/player-small.aseprite --save-as src/images/player-small.png
	aseprite -b assets/images/player.aseprite --save-as src/images/player.png
	aseprite -b assets/images/ball.aseprite --save-as src/images/ball.png
	aseprite -b assets/images/ball-jack.aseprite --save-as src/images/ball-jack.png
	aseprite -b assets/images/ball-black.aseprite --save-as src/images/ball-black.png
	aseprite -b assets/images/ball-white.aseprite --save-as src/images/ball-white.png
	aseprite -b assets/images/ball-black-gray.aseprite --save-as src/images/ball-black-gray.png
	aseprite -b assets/images/ball-white-gray.aseprite --save-as src/images/ball-white-gray.png
	aseprite -b --layer "Position Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-position-phase.png
	aseprite -b --layer "Direction Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-direction-phase.png
	aseprite -b --layer "Power Phase" assets/images/phase-overlays.aseprite --save-as src/images/overlay-power-phase.png
