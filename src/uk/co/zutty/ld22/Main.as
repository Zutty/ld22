package uk.co.zutty.ld22
{
    import flash.display.Sprite;
    import flash.geom.Point;
    
    import net.flashpunk.Engine;
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    
    import uk.co.zutty.ld22.entities.Banality;
    import uk.co.zutty.ld22.entities.Bleakness;
    import uk.co.zutty.ld22.entities.PowerWord;
    import uk.co.zutty.ld22.worlds.GameWorld;
    import uk.co.zutty.ld22.worlds.TitleScreen;
    
    public class Main extends Engine {
        
        public static var vector:Vector2D = new Vector2D(0, 0);
        
        public static const banalities:Supplier = Supplier.newSupplier(64, function():Entity { return new Banality() });
        public static const bleaknesses:Supplier = Supplier.newSupplier(64, function():Entity { return new Bleakness() });
        
        private static var titleScreen:TitleScreen;
        private static var gameWorld:GameWorld;
        
        private static var level:int = 0;
        
        public function Main() {
            super(320, 240, 60, false);
            FP.screen.scale = 2;
            FP.screen.color = 0x000000;
            //FP.console.enable();
            
            Supplier.initAll();
            
            titleScreen = new TitleScreen();
            goToTitleScreen();
        }
        
        public static function goToTitleScreen():void {
            level = 0;
            FP.world = titleScreen;
        }

        public static function nextLevel():void {
            level++;
            FP.world = new GameWorld();
        }
    }
}