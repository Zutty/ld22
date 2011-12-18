package uk.co.zutty.ld22.worlds
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;
    
    public class TitleScreen extends TransitionWorld {
        
        [Embed(source = 'assets/title.png')]
        private const TITLE_IMAGE:Class;

        public function TitleScreen() {
            super();
            
            var f:Entity = new Entity();
            var img:Image = new Image(TITLE_IMAGE);
            img.centerOrigin();
            f.graphic = img;
            f.x = 160;
            f.y = 50;
            add(f);

            var e:Entity = new Entity();
            var txt:Text = new Text("Press X to start");
            txt.width = FP.width;
            txt.align = "center";
            e.graphic = txt;
            e.y = 200;
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