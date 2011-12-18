package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    
    import uk.co.zutty.ld22.Main;

    public class Bystander extends Speaker {
        
        [Embed(source = 'assets/bystander.png')]
        private const BYSTANDER_IMAGE:Class;
        
        private var _img:Image;
        private var _target:Entity;
        private var _jumped:Boolean;

        public function Bystander(x:Number, y:Number) {
            super(x, y);
            _img = new Image(BYSTANDER_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            setHitbox(16, 32, 8, 16);
            speakCooldown = 200;
        }

        public function set target(t:Entity):void {
            _target = t;
        }
        
        public function get targetInRange():Boolean {
            return true;
        }
        
        override public function doFire(char:String):void {
            Banality(Main.banalities.next()).fireAt(char, x, y, velocity, _target);            
        }
        
        override public function update():void {
            super.update();
            if(_target && targetInRange && canSpeak) {
                speak("Lovely weather", _target.x > x);
            }
        }
    }
}