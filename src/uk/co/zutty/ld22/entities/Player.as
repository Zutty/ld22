package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    public class Player extends GravityEntity {
        
        private const MOVE_SPEED:Number = 2;
        private const JUMP_IMPULSE:Number = 6;
        
        [Embed(source = 'assets/guy.png')]
        private const GUY_IMAGE:Class;
        
        private var _img:Image;
        private var jumped:Boolean;
        
        public function Player() {
            super();
            _img = new Image(GUY_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            setHitbox(16, 32, 8, 16);
            
            jumped = false;
            
            Input.define("jump", Key.SPACE);
            Input.define("up", Key.W, Key.UP);
            Input.define("down", Key.S, Key.DOWN);
            Input.define("left", Key.A, Key.LEFT);
            Input.define("right", Key.D, Key.RIGHT);
        }
        
        override protected function onHitGround():void {
            jumped = false;
        }
        
        override public function update():void {
            super.update();
            
            if(Input.check("jump") && !jumped) {
                velocity.y = -JUMP_IMPULSE;
                jumped = true;
            }

            velocity.x = 0;
            if(Input.check("left")) {
                velocity.x = -MOVE_SPEED;
            }
            if(Input.check("right")) {
                velocity.x = MOVE_SPEED;
            }
        }
    }
}