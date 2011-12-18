package uk.co.zutty.ld22.entities
{
    import flash.filters.GlowFilter;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.Sfx;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;
    import uk.co.zutty.ld22.SfxSupplier;
    import uk.co.zutty.ld22.Supplier;
    import uk.co.zutty.ld22.worlds.GameWorld;
    
    public class Player extends Speaker {
        
        public static const QUOTES:Array = [
            "There is no truth",
            "Death is inevitable",
            "The world is irrational",
            "Hell is other people",
            "We are bugs in amber",
            "No reality except in action",
            "No passion without struggle"
            ];
        
        public static const MOVE_SPEED:Number = 2;
        public static const JUMP_IMPULSE:Number = 6;
        public static const HEAL_OVER_TIME:Number = 0.02;
        public static const HEAL_ONE_SHOT:Number = 15;
        public static const HEAL_MAX_CHARGES:Number = 5;
        public static const FIRE_SELF_DAMAGE:Number = 2;
        public static const HEAL_COOLDOWN:int = 20;
        public static const FLASH_TICKS:int = 3;
        
        [Embed(source = 'assets/guy.png')]
        private const GUY_IMAGE:Class;
        
        [Embed(source = 'assets/fags.mp3')]
        private const FAGS_SOUND:Class;
        [Embed(source = 'assets/pickup.mp3')]
        private const PICKUP_SOUND:Class;
        [Embed(source = 'assets/jump.mp3')]
        private const JUMP_SOUND:Class;
        [Embed(source = 'assets/drag.mp3')]
        private const DRAG_SOUND:Class;
        [Embed(source = 'assets/dread.mp3')]
        private const DREAD_SOUND:Class;
        [Embed(source = 'assets/terror.mp3')]
        private const TERROR_SOUND:Class;
        [Embed(source = 'assets/hit.mp3')]
        private const HIT_SOUND:Class;

        private var _gfx:Graphiclist;
        private var _img:Image;
        private var _jumped:Boolean;
        private var _dead:Boolean;
        private var _healTick:int;
        private var _healCharges:int;
        private var _flash:int;
        private var _lastDirection:Boolean;
        private var _powerUp:Boolean;
        
        private var _pickupSfx:Sfx;
        private var _fagsSfx:Sfx;
        private var _jumpSfx:Sfx;
        private var _dragSfx:Sfx;
        private var _dreadSfx:Sfx;
        private var _terrorSfx:Sfx;
        private var _hitSfxSuplier:SfxSupplier;
        
        private var _message:Text;
        private var _messageTick:int;
        
        public function Player() {
            super(0, 0);
            _gfx = new Graphiclist();
            _img = new Image(GUY_IMAGE);
            _img.centerOrigin();
            _gfx.add(_img);
            graphic = _gfx;
            setHitbox(12, 28, 6, 14);
            
            _fagsSfx = new Sfx(FAGS_SOUND);
            _pickupSfx =  new Sfx(PICKUP_SOUND);
            _jumpSfx = new Sfx(JUMP_SOUND);
            _dragSfx = new Sfx(DRAG_SOUND);
            _dreadSfx = new Sfx(DREAD_SOUND);
            _terrorSfx = new Sfx(TERROR_SOUND);
            _hitSfxSuplier = new SfxSupplier(8, HIT_SOUND);
            _hitSfxSuplier.init();
            
            _maxDamage = 100;
            speakCooldown = 120;
            _powerUp = false;
            
            // Set up message
            _message = new Text("Woot!");
            _message.centerOrigin();
            _message.align = "center";
            _message.y -= 20;
            _message.color = 0xd6c756;
            _message.field.filters = [new GlowFilter(0x000000, 1, 4, 4)];
            _message.size = 8;
            _message.alpha = 0.0;
            _gfx.add(_message);
            
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
            _healTick = 0;
            _flash = 0;
            _healCharges = 3;
            _dead = false;
        }
        
        public function die():void {
            active = false;
            visible = false;
            _dead = true;
            _utterance = "";
            if(FP.world is GameWorld) {
                for(var i:int = 0; i < 4; i++) {
                    Cloud(GameWorld(FP.world).clouds.next()).poof(x, y);
                }
            }
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
        
        public function get isPoweredUp():Boolean {
            return _powerUp;
        }
        
        public function set message(msg:String):void {
            _message.text = msg;
            _message.centerOrigin();
            _message.visible = true;
            _messageTick = 150;
        }
        
        override public function doFire(char:String):void {
            Bleakness(GameWorld(FP.world).bleaknesses.next()).fire(char, x, y, velocity, _lastDirection ? 0 : 180);
            _damage += FIRE_SELF_DAMAGE;
        }
        
        public function get randomQuote():String {
            return FP.choose(QUOTES);
        }
        
        override public function update():void {
            super.update();
            
            _message.alpha = 1.0;
            if(_message.visible && _messageTick <= 0) {
                _message.visible = false;
            } else if(_messageTick > 0) {
                _messageTick--;
            }
            
            // Slowly heal self
            _damage = FP.clamp(_damage - HEAL_OVER_TIME, 0, _maxDamage);

            // Collect powerups
            var powerup:Entity = collide("powerup", x, y);
            if(powerup) {
                if(powerup is Cigarette) {
                    _healCharges = Math.min(_healCharges + 1, HEAL_MAX_CHARGES);
                    _fagsSfx.play();
                } else if(powerup is Manuscript) {
                    _powerUp = true;
                    _pickupSfx.play();
                }
                FP.world.remove(powerup);
            }

            // Take damage from baddies
            var damager:Damager = collide("damager", x, y) as Damager;
            if(damager && damager.active) {
                if(damager is Baddie && !_terrorSfx.playing) {
                    _terrorSfx.play();
                } else if(!(damager is Baddie)) {
                    _hitSfxSuplier.next().play();
                }
                if(damager is PowerWord) {
                    damager.collidable = false;
                }
                _damage = FP.clamp(_damage + damager.damage, 0, _maxDamage);
            }
            
            // Fire/speak
            if(Input.check("fire") && canSpeak && velocity.y == 0) {
                _dreadSfx.play();
                speak(randomQuote, _lastDirection);
            }
            
            // Self heal
            if(Input.check("heal") && _healTick <= 0 && _healCharges > 0) {
                _damage -= HEAL_ONE_SHOT;
                _healCharges--;
                _dragSfx.play();
                _healTick = HEAL_COOLDOWN; 
            }

            // Jump/move
            if(Input.check("jump") && !_jumped && !isSpeaking) {
                _jumpSfx.play();
                velocity.y = -JUMP_IMPULSE;
                _jumped = true;
            }

            // Move left/right
            velocity.x = 0;
            if(Input.check("left") && x > 8) {
                velocity.x = isSpeaking ? -MOVE_SPEED / 2 : -MOVE_SPEED;
                _lastDirection = false;
            }
            if(Input.check("right") && x < (FP.world as GameWorld).level.width - 8) {
                velocity.x = isSpeaking ? MOVE_SPEED / 2 : MOVE_SPEED;
                _lastDirection = true;
            }
            
            // Count down the heal timer tick
            if(_healTick > 0) {
                _healTick--;
            }

            // Flash if trapped
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