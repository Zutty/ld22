package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    import uk.co.zutty.ld22.Main;
    
    public class Speaker extends GravityEntity {
        
        public static const FIRE_COOLDOWN:int = 3;
        
        private var _speakTick:int;
        private var _fireTick:int;
        private var _utterance:String;
        private var _speakCooldown:int;

        public function Speaker(x:Number, y:Number) {
            super(x, y);
            _fireTick = 0;
            _utterance = "";
        }
        
        public function set speakCooldown(cd:int):void {
            _speakCooldown = cd;
        }
        
        public function speak(words:String, flip:Boolean):void {
            _speakTick = _speakCooldown;
            _utterance = words;
            if(flip) {
                _utterance = _utterance.split("").reverse().join("");
            }
        }
        
        public function doFire(char:String):void {};
        
        public function get canSpeak():Boolean {
            return _speakTick <= 0;
        }
        
        public function get isSpeaking():Boolean {
            return _utterance.length > 0;
        }
        
        override public function update():void {
            super.update();
            
            if(_speakTick > 0) {
                _speakTick--;
            }
            
            if(isSpeaking && _fireTick <= 0) {
                doFire(_utterance.charAt());
                _utterance = _utterance.substr(1);
                _fireTick = FIRE_COOLDOWN;
            } else {
                _fireTick--;
            }
        }
    }
}