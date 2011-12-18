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
        
        public static const MOVE_SPEED:Number = 2;
        public static const JUMP_IMPULSE:Number = 6;
        public static const HEAL_OVER_TIME:Number = 0.02;
        public static const HEAL_ONE_SHOT:Number = 15;
        public static const HEAL_MAX_CHARGES:Number = 5;
        public static const FIRE_SELF_DAMAGE:Number = 25;
        public static const FIRE_COOLDOWN:int = 20;
        public static const HEAL_COOLDOWN:int = 20;
        public static const FLASH_TICKS:int = 3;
        
        [Embed(source = 'assets/guy.png')]
        private const GUY_IMAGE:Class;
        
        private var _img:Image;
        private var _jumped:Boolean;
        private var _dead:Boolean;
        private var _fireTick:int;
        private var _healTick:int;
        private var _healCharges:int;
        private var _flash:int;
        
        public function Player() {
            super();
            _img = new Image(GUY_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            setHitbox(16, 32, 8, 16);
            
            _maxDamage = 100;
            
            Input.define("jump", Key.SPACE, Key.W, Key.UP);
            //Input.define("up", Key.W, Key.UP);
            //Input.define("down", Key.S, Key.DOWN);
            Input.define("left", Key.A, Key.LEFT);
            Input.define("right", Key.D, Key.RIGHT);

            Input.define("fire", Key.X);
            Input.define("heal", Key.C);
            
            die();
        }
        
        override public function spawn():void {
            super.spawn();
            active = true;
            visible = true;
            _jumped = false;
            _damage = 0;
            _fireTick = 0;
            _healTick = 0;
            _flash = 0;
            _healCharges = 3;
            _dead = false;
        }
        
        public function die():void {
            active = false;
            visible = false;
            _dead = true;
        }
        
        public function get dead():Boolean {
            return _dead;
        }
        
        public function get healCharges():int {
            return _healCharges;
        }

        override protected function onHitGround():void {
            _jumped = false;
        }
        
        override public function update():void {
            super.update();
            
            // Slowly heal self
            _damage = FP.clamp(_damage - HEAL_OVER_TIME, 0, _maxDamage);

            // Take damage from baddies
            var damager:Damager = collide("damager", x, y) as Damager;
            if(damager && damager.active) {
                _damage = FP.clamp(_damage + damager.damage, 0, _maxDamage);
            }
            
            if(Input.check("jump") && !_jumped) {
                velocity.y = -JUMP_IMPULSE;
                _jumped = true;
            }

            // Fire and self heal
            if(Input.check("fire") && _fireTick <= 0) {
                _damage += FIRE_SELF_DAMAGE;
                _fireTick = FIRE_COOLDOWN; 
            }
            if(Input.check("heal") && _healTick <= 0 && _healCharges > 0) {
                _damage -= HEAL_ONE_SHOT;
                _healCharges--;
                _healTick = HEAL_COOLDOWN; 
            }

            velocity.x = 0;
            if(Input.check("left") && x > 8) {
                velocity.x = -MOVE_SPEED;
            }
            if(Input.check("right") && x < 1192) {
                velocity.x = MOVE_SPEED;
            }
            
            // Sundries
            if(_fireTick > 0) {
                _fireTick--;
            }
            if(_healTick > 0) {
                _healTick--;
            }
            
            if(!trapped) {
                _img.alpha = 1;
                _flash = 0;
            } else {
                if(_flash <= 0) {
                    _img.alpha = 1 - _img.alpha;
                    _flash = FLASH_TICKS;
                } else {
                    _flash--;
                }
            }
        }
    }
}