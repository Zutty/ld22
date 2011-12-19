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
            Main.handleMute(_musicSfx);
            
            var f:Entity = new Entity();
            var img:Image = new Image(TITLE_IMAGE);
            img.centerOrigin();
            f.graphic = img;
            f.x = 160;
            f.y = 50;
            add(f);

            var g:Entity = new Entity();
            var ins:Text = new Text("Overcome self doubt in the face of\n asinie banality. Use your ideology\nto dismiss uninformed bystanders, but be\n careful to avoid turmoil and, ultimately, an\n existential crisis.");
            ins.centerOrigin();
            ins.width = FP.width;
            ins.size = 12;
            ins.align = "center";
            g.graphic = ins;
            g.width = FP.width;
            g.x = FP.halfWidth;
            g.y = 150;
            add(g);

            var e:Entity = new Entity();
            var txt:Text = new Text("Press X to start");
            txt.width = FP.width;
            txt.align = "center";
            e.graphic = txt;
            e.y = 190;
            add(e);

            var h:Entity = new Entity();
            var tt:Text = new Text("Made by Zutty for #LD22\nwww.ludumdare.com");
            tt.centerOrigin();
            tt.size = 8;
            tt.align = "right";
            h.graphic = tt;
            h.width = FP.width;
            h.x = 210;
            h.y = 238;
            add(h);
}
        
        override public function update():void {
            super.update();
            
            if(Input.pressed(Key.M)) {
                Main.toggleMute();
                Main.handleMute(_musicSfx);
            }

            if(Input.pressed(Key.X)) {
                _musicSfx.stop();
                Main.nextLevel(); 
            }
        }    
    }
}