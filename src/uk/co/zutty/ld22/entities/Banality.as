package uk.co.zutty.ld22.entities
{
    import flash.filters.GlowFilter;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Text;
    
    import uk.co.zutty.ld22.Vector2D;
    
    public class Banality extends Damager {
        
        public const SPEED:Number = 2.1;
        public const MARGIN:Number = 20;
        
        private var _txt:Text;
        private var _velocity:Vector2D = new Vector2D(0, 0);
        
        public function Banality() {
            super(0, 0);
            
            _txt = new Text("");
            _txt.smooth = true;
            _txt.size = 8;
            _txt.color = 0xFFFFFF;
            _txt.field.filters = [new GlowFilter(0x000000, 1, 4, 4)];
            _txt.x = -4;
            _txt.y = -4;
            graphic = _txt;
            
            setHitbox(8, 8, 4, 4);
            type = "damager";
            damage = 0.1;
            active = false;
            visible = false;
        }
        
        public function fire(char:String, x:Number, y:Number, target:Entity):void {
            _velocity.setCartesian(x, y, target.x, target.y);
            _velocity.magnitude = SPEED;
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