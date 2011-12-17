package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    public class Player extends Entity {
        
        private const MOVE_SPEED:Number = 3;
        
        [Embed(source = 'assets/guy.png')]
        private const GUY_IMAGE:Class;
        
        private var _img:Image;
        
        public function Player() {
            super();
            _img = new Image(GUY_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            
            Input.define("up", Key.W, Key.UP);
            Input.define("down", Key.S, Key.DOWN);
            Input.define("left", Key.A, Key.LEFT);
            Input.define("right", Key.D, Key.RIGHT);
        }
        
        override public function update():void {
            if(Input.check("up")) {
                y -= MOVE_SPEED;
            }
            if(Input.check("down")) {
                y += MOVE_SPEED;
            }
            if(Input.check("left")) {
                x -= MOVE_SPEED;
            }
            if(Input.check("right")) {
                x += MOVE_SPEED;
            }
        }
    }
}