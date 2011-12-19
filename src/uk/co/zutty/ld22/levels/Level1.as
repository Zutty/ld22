package uk.co.zutty.ld22.levels
{
    public class Level1 extends OgmoLevel {
        [Embed(source = 'assets/level1.oel', mimeType = 'application/octet-stream')]
        private const LEVEL1_OEL:Class;
        
        [Embed(source = 'assets/happy_tiles.png')]
        private const HAPPY_TILES_IMAGE:Class;

        [Embed(source = 'assets/sad_tiles.png')]
        private const SAD_TILES_IMAGE:Class;

        public function Level1() {
            super(LEVEL1_OEL, {sky: HAPPY_TILES_IMAGE, ground:HAPPY_TILES_IMAGE, overlay:HAPPY_TILES_IMAGE, sad_sky: SAD_TILES_IMAGE, sad_ground:SAD_TILES_IMAGE, sad_overlay:SAD_TILES_IMAGE}, 16, 16);
        }
    }
}