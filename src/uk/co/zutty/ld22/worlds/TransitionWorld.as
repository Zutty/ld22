package uk.co.zutty.ld22.worlds
{
    import flash.display.Sprite;
    
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    public class TransitionWorld extends World {
        
        private var _sprite:Sprite = new Sprite();
        
        public function TransitionWorld() {
            super();
            _sprite.graphics.beginFill(0x000000);
            _sprite.graphics.drawRect(0, 0, FP.width, FP.height);
            _sprite.graphics.endFill();
        }
        
        public function fadeIn():void {
            
        }
        
        public function fadeOut():void {
            
        }
        
        override public function render():void {
            super.render();
        }
    }
}