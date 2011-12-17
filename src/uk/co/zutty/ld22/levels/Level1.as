package uk.co.zutty.ld22.levels
{
    public class Level1 extends OgmoLevel {
        [Embed(source = 'assets/level1.oel', mimeType = 'application/octet-stream')]
        private const LEVEL1_OEL:Class;
        
        [Embed(source = 'assets/happy_tiles.png')]
        private const HAPPY_TILES_IMAGE:Class;
        
        public function Level1() {
            super(LEVEL1_OEL, {sky: HAPPY_TILES_IMAGE, ground:HAPPY_TILES_IMAGE}, 16, 16);
        }
    }
}