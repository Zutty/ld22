package uk.co.zutty.ld22.entities
{
    import flash.filters.GlowFilter;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Text;
    
    import uk.co.zutty.ld22.Vector2D;
    
    public class PowerWord extends Damager {
        
        public const SPEED:Number = 1.5;
        public const MARGIN:Number = 20;
        
        protected var _txt:Text;
        private var _velocity:Vector2D = new Vector2D(0, 0);
        
        public function PowerWord(textColour:uint, glowColour:uint) {
            super(0, 0);
            
            _txt = new Text("");
            _txt.smooth = true;
            _txt.size = 8;
            _txt.color = textColour;
            _txt.alpha = 0;
            _txt.field.filters = [new GlowFilter(glowColour, 1, 4, 4)];
            _txt.x = -4;
            _txt.y = -4;
            graphic = _txt;
            
            setHitbox(8, 8, 4, 4);
            damage = 0.5;
            active = false;
            visible = false;
        }
        
        public function fire(char:String, x:Number, y:Number, initV:Vector2D, angle:Number):void {
            _velocity.setPolar(angle, SPEED);
            _velocity.add(initV);
            doFire(char, x, y);
        }

        public function fireAt(char:String, x:Number, y:Number, initV:Vector2D, target:Entity):void {
            _velocity.setCartesian(x, y, target.x, target.y);
            _velocity.magnitude = SPEED;
            _velocity.add(initV);
            doFire(char, x, y);
        }
            
        private function doFire(char:String, x:Number, y:Number):void {
            _txt.text = char;
            _txt.angle = _velocity.angle - 90;
            
            if(_txt.angle < -90) {
                _txt.angle -= 180;
            }
                
            this.x = x;
            this.y = y;
            active = true;
            visible = true;
        }
        
        override public function update():void {
            _txt.alpha = 1.0;
            super.update();
            x += _velocity.x;
            y += _velocity.y;
            
            if(x < FP.camera.x - MARGIN || x > FP.camera.x + FP.width + MARGIN || y < FP.camera.y - MARGIN || y > FP.camera.y + FP.height + MARGIN) {
                active = false;
                visible = false;
            }
        }
    }
}