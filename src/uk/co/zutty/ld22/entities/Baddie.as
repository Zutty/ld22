package uk.co.zutty.ld22.entities
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    import uk.co.zutty.ld22.Main;
    import uk.co.zutty.ld22.Vector2D;
    
    public class Baddie extends Entity {
        
        private const MOVE_SPEED:Number = 2;
        private const DEVIATION:Number = 60;
        private const P_MOVE:Number = 0.02;
        
        [Embed(source = 'assets/baddie.png')]
        private const BADDIE_IMAGE:Class;
        
        private var _img:Image;
        private var _origin:Point;
        private var _waypoint:Point = new Point(0, 0);
        private var _move:Boolean;
        private var _velocity:Vector2D;

        public function Baddie(x:Number=0, y:Number=0) {
            super(x, y);
            _img = new Image(BADDIE_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            _move = false;
            _origin = new Point(x, y);
            _velocity = new Vector2D(0, 0);
            
            setHitbox(16, 16, 8, 8);
            type = "baddie";
        }

        public function goTo(wx:Number, wy:Number):void {
            _waypoint.x = wx;
            _waypoint.y = wy;
            _velocity.setCartesian(x, y, _waypoint.x, _waypoint.y);
            _velocity.magnitude = MOVE_SPEED;
            _move = true;
        }

        public function goToRel(v:Vector2D):void {
            goTo(_origin.x + v.x, _origin.y + v.y);
        }
        
        public function get reachedWaypoint():Boolean {
            return Math.abs(_waypoint.x - x) < MOVE_SPEED && Math.abs(_waypoint.y - y) < MOVE_SPEED;
        }
        
        override public function update():void {
            super.update();
            
            if(!_move && Math.random() < P_MOVE) {
                Main.vector.setPolar(Math.random() * 360, Math.random() * DEVIATION);
                goToRel(Main.vector);
            }

            if(_move) {
                x += _velocity.x;
                y += _velocity.y;
                
                if(reachedWaypoint) {
                    x = _waypoint.x;
                    y = _waypoint.y;
                    _move = false;
                }
            }
        }
    }
}