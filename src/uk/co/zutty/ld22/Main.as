package uk.co.zutty.ld22
{
    import flash.display.Sprite;
    import flash.geom.Point;
    
    import net.flashpunk.Engine;
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    import uk.co.zutty.ld22.entities.Banality;
    import uk.co.zutty.ld22.entities.Bleakness;
    import uk.co.zutty.ld22.entities.PowerWord;
    import uk.co.zutty.ld22.worlds.GameWorld;
    import uk.co.zutty.ld22.worlds.TitleScreen;
    import uk.co.zutty.ld22.worlds.WinScreen;
    
    public class Main extends Engine {
        
        public static const NUM_LEVELS:int = 1;
        
        private static var titleScreen:TitleScreen;
        public static var vector:Vector2D = new Vector2D(0, 0);
        
        private static var level:int = 0;
        
        public function Main() {
            super(320, 240, 60, false);
            FP.screen.scale = 2;
            FP.screen.color = 0x000000;
            //FP.console.enable();
            
            Supplier.initAll();
            
            goToTitleScreen();
        }
        
        public static function goToTitleScreen():void {
            level = 0;
            FP.world = new TitleScreen();
        }

        public static function nextLevel():void {
            level++;
            if(level > NUM_LEVELS) {
                FP.world = new WinScreen();
            } else {
                FP.world = new GameWorld();
            }
        }
    }
}