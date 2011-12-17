package uk.co.zutty.ld22
{
    import flash.display.Sprite;
    import flash.geom.Point;
    
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    
    public class Main extends Engine {
        
        public static var vector:Vector2D = new Vector2D(0, 0);
        
        public function Main() {
            super(320, 240, 60, false);
            FP.screen.scale = 2;
            FP.screen.color = 0x000000;
            FP.console.enable();
            FP.world = new GameWorld();
        }
    }
}