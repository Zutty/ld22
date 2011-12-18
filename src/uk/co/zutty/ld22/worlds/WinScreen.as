package uk.co.zutty.ld22.worlds
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;

    public class WinScreen extends TransitionWorld {
        
        [Embed(source = 'assets/fin.png')]
        private const FIN_IMAGE:Class;

        private var _tick:int;
        
        public function WinScreen() {
            super();
            
            var f:Entity = new Entity();
            var img:Image = new Image(FIN_IMAGE);
            img.centerOrigin();
            f.graphic = img;
            f.x = 160;
            f.y = 120;
            add(f);
            
            _tick = 100;
        }
        
        override public function update():void {
            super.update();
            
            if(--_tick <= 0) {
                Main.goToTitleScreen(); 
            }
        }    
    }
}