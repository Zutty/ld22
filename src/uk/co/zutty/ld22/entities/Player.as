package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    public class Player extends GravityEntity {
        
        public static const MAX_DAMAGE:Number = 100;
        public static const MOVE_SPEED:Number = 2;
        public static const JUMP_IMPULSE:Number = 6;
        public static const HEAL_RATE:Number = 0.02;
        
        [Embed(source = 'assets/guy.png')]
        private const GUY_IMAGE:Class;
        
        private var _img:Image;
        private var _jumped:Boolean;
        private var _damage:Number;
        
        public function Player() {
            super();
            _img = new Image(GUY_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            setHitbox(16, 32, 8, 16);
            
            _jumped = false;
            _damage = 0;
            
            Input.define("jump", Key.SPACE);
            Input.define("up", Key.W, Key.UP);
            Input.define("down", Key.S, Key.DOWN);
            Input.define("left", Key.A, Key.LEFT);
            Input.define("right", Key.D, Key.RIGHT);
        }
        
        public function get damage():Number {
            return _damage;
        }
        
        override protected function onHitGround():void {
            _jumped = false;
        }
        
        override public function update():void {
            super.update();
            
            // Take damage from baddies
            var damager:Damager = collide("damager", x, y) as Damager;
            if(damager) {
                _damage = FP.clamp(_damage + damager.damage, 0, MAX_DAMAGE);
            }

            // Slowly heal self
            _damage = FP.clamp(_damage - HEAL_RATE, 0, MAX_DAMAGE);
            
            if(Input.check("jump") && !_jumped) {
                velocity.y = -JUMP_IMPULSE;
                _jumped = true;
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