package uk.co.zutty.ld22.worlds
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;
    
    public class TitleScreen extends TransitionWorld {
        
        public function TitleScreen() {
            super();
            
            var e:Entity = new Entity();
            var txt:Text = new Text("Press X to start");
            txt.align = "center";
            e.graphic = txt;
            e.y = (FP.height - txt.textHeight) / 2;
            add(e);
        }
        
        override public function update():void {
            super.update();
            
            if(Input.pressed(Key.X)) {
                Main.nextLevel(); 
            }
        }    
    }
}