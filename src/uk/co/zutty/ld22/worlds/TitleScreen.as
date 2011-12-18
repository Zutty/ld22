package uk.co.zutty.ld22.worlds
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;
    
    public class TitleScreen extends TransitionWorld {
        
        [Embed(source = 'assets/title.png')]
        private const TITLE_IMAGE:Class;
        [Embed(source = 'assets/music1.mp3')]
        private const MUSIC1_SOUND:Class;
        
        private var _musicSfx:Sfx;

        public function TitleScreen() {
            super();
            
            _musicSfx = new Sfx(MUSIC1_SOUND);
            _musicSfx.loop();
            
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
            
            if(Input.pressed(Key.M)) {
                _musicSfx.volume = 1 - _musicSfx.volume;
            }

            if(Input.pressed(Key.X)) {
                _musicSfx.stop();
                Main.nextLevel(); 
            }
        }    
    }
}