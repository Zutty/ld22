package uk.co.zutty.ld22
{
    import flash.display.Sprite;
    
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    
    public class Main extends Engine {
        public function Main() {
            super(320, 240, 60, false);
            FP.screen.scale = 2;
        }
    }
}