# aniTiles
animated tiles - 8x8 led matrix

Online editor/player: http://anitiles.blinkingnoise.org/
Demo video: https://www.youtube.com/watch?v=QPlTU5hJs_Y


## aniTilesPlayer (Processing 3)
aniTilesPlayer is a standalone player with following features: 
 - use with / without aniTiles hardware (Rainbowduino)
 - autofetch of new animations
 - playlist support
 - blacklist support
 - midi sync

 ## aniTiles_Rainbowduino
 Arduino sketch for the Rainbowduino board (V3.0).
 This sketch reads one frame (192 bytes) @ 19200 baud and write it to the led matrix.
 
 Serail Protocol:
 - 19200 Baud
 - 192 bytes per frame
 - 8 bits per color (red/green/blue)
 - sends 0x00 when frame has been written to the led matrix
 - sends 0xFF on error or timeout
