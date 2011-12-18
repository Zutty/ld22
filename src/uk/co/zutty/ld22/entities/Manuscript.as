package uk.co.zutty.ld22.entities
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;
    
    public class Manuscript extends Entity {
        
        [Embed(source = 'assets/manuscript.png')]
        private const MANUSCRIPT_IMAGE:Class;
        
        private var _img:Image;

        public function Manuscript(x:Number, y:Number) {
            super(x, y);
            _img = new Image(MANUSCRIPT_IMAGE);
            _img.centerOrigin();
            graphic = _img;
            setHitbox(16, 16, 8, 8);
            type = "powerup";
        }
    }
}