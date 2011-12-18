package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    import uk.co.zutty.ld22.Vector2D;
    
    public class Cloud extends Entity {

        [Embed(source = 'assets/cloud.png')]
        private const CLOUD_IMAGE:Class;
        
        private var _img:Image;
        private var _velocity:Vector2D;
        private var _rotation:Number;
        private var _tick:int;
        private var _lifespan:int;

        public function Cloud() {
            super(0, 0);
            _img = new Image(CLOUD_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            _velocity = new Vector2D(0, 0);
            _rotation = 0;
            _tick = 0;
            _lifespan = 0;
            active = false;
            visible = false;
        }
        
        public function poof(x:Number, y:Number):void {
            this.x = x + (Math.random() * 4) - 2;
            this.y = y + (Math.random() * 4) - 2;
            _img.angle = (Math.random() * 360)
            _velocity.x = (Math.random() * 3) - 1.5;
            _velocity.x = (Math.random() * 3) - 1.5;
            _rotation = (Math.random() * 3) + 3;
            active = true;
            visible = true;
            _lifespan = (Math.random() * 5) + 15;
            _tick = _lifespan;
        }
        
        override public function update():void {
            super.update();
            _img.angle += _rotation;
            _img.alpha = 1 - (_tick / _lifespan);
            x += _velocity.x;
            y += _velocity.y;
            _tick--;
            if(_tick <= 0) {
                active = false;
                visible = false;
            }
        }
    }
}