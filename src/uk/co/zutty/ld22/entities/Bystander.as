package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    import uk.co.zutty.ld22.Main;
    
    public class Bystander extends GravityEntity {
        
        [Embed(source = 'assets/bystander.png')]
        private const BYSTANDER_IMAGE:Class;
        
        private var _img:Image;
        private var _jumped:Boolean;
        private var _speakTick:int;
        private var _fireTick:int;
        private var _target:Entity;
        private var _utterance:String;

        public function Bystander(x:Number, y:Number) {
            super(x, y);
            _img = new Image(BYSTANDER_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            setHitbox(16, 32, 8, 16);
            _fireTick = 0;
        }
        
        public function set target(t:Entity):void {
            _target = t;
        }
        
        public function get targetInRange():Boolean {
            return true;
        }
        
        override public function update():void {
            super.update();
            
            if(_target && targetInRange && _speakTick <= 0) {
                _speakTick = 200;
                _utterance = "Lovely weather";
                if(_target.x > x) {
                    _utterance = _utterance.split("").reverse().join("");
                }
            } else {
                _speakTick--;
            }
            
            if(_utterance.length > 0 && _fireTick <= 0) {
                Banality(Main.banalities.next()).fire(_utterance.charAt(), x, y, _target);
                _utterance = _utterance.substr(1);
                _fireTick = 2;
            } else {
                _fireTick--;
            }
        }
    }
}