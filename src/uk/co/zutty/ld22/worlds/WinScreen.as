package uk.co.zutty.ld22.worlds
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;

    public class WinScreen extends TransitionWorld {
        
        private var _tick:int;
        
        public function WinScreen() {
            super();
            
            var e:Entity = new Entity();
            var txt:Text = new Text("Fin");
            txt.size = 24;
            txt.width = FP.width;
            txt.align = "center";
            e.graphic = txt;
            e.y = (FP.height - txt.textHeight) / 2;
            add(e);
            
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