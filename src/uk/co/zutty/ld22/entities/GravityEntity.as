package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    
    import uk.co.zutty.ld22.Vector2D;
    import uk.co.zutty.ld22.levels.Layer;
    
    public class GravityEntity extends Entity {
        
        private const G:Number = 0.5; 
        private const TRAPPED_TIMER:int = 35;
        
        private var g:Number;
        private var _velocity:Vector2D = new Vector2D(0, 0);
        protected var _damage:Number;
        protected var _maxDamage:Number;
        private var _onTrapped:Function;
        private var _trapped:Boolean;
        private var _trappedTick:int;
        
        public function GravityEntity(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) {
            super(x, y, graphic, mask);
            g = 0;
            _trapped = false;
            _trappedTick = 0;
        }
        
        public function spawn():void {
            _trapped = false;
            _trappedTick = 0;
        }
        
        public function get damagePct():Number {
            return _damage / _maxDamage;
        }

        public function get damage():Number {
            return _damage;
        }
        
        public function get maxDamage():Number {
            return _maxDamage;
        }

        protected function get velocity():Vector2D {
            return _velocity;
        }
        
        public function get trapped():Boolean {
            return _trapped;
        }
        
        public function set onTrapped(f:Function):void {
            _onTrapped = f;
        }
        
        protected function onHitGround():void {}
        
        override public function update():void {
            super.update();
            var checkTrapped:Boolean = false;
            
            var solid:Entity = collide("solid", x, y);
            if(solid) {
                checkTrapped = true;
            }

            solid = collide("solid", x + _velocity.x, y);
            if(solid) {
                _velocity.x = 0;
            } else {
                checkTrapped = false;
            }

            _velocity.y += G;
            
            solid = collide("solid", x, y + _velocity.y);
            if(solid) {
                _velocity.y = 0;
                onHitGround();
                
                if(checkTrapped && _onTrapped != null) {
                    _trapped = true;
                    _trappedTick++;
                    // You are trapped and cant move
                    if(_trappedTick > TRAPPED_TIMER) {
                        _onTrapped();
                    }
                }
            }
            
            if(!checkTrapped) {
                _trapped = false;
            }
            
            x += velocity.x;
            y += velocity.y;
            
            if(!_trapped) {
                _trappedTick = 0;
            }
        }
    }
}