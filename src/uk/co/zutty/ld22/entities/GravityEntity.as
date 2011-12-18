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
        
        private var g:Number;
        private var _velocity:Vector2D = new Vector2D(0, 0);
        protected var _damage:Number;
        protected var _maxDamage:Number;
        
        public function GravityEntity(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) {
            super(x, y, graphic, mask);
            g = 0;
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
        
        protected function onHitGround():void {}
        
        override public function update():void {
            super.update();
            
            var solid:Entity = collide("solid", x + _velocity.x, y);
            if(solid) {
                _velocity.x = 0;
            }

            _velocity.y += G;
            
            solid = collide("solid", x, y + _velocity.y);
            if(solid) {
                _velocity.y = 0;
                onHitGround();
            }
            
            x += velocity.x;
            y += velocity.y;
        }
    }
}