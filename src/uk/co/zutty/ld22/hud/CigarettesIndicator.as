package uk.co.zutty.ld22.hud
{
    import flash.filters.GlowFilter;
    
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    
    public class CigarettesIndicator extends Entity {
        
        [Embed(source = 'assets/cigarettes_sml.png')]
        private const CIGARETTES_IMAGE:Class;

        private var _gfx:Graphiclist;
        private var _img:Image;
        private var _txt:Text;
        
        public function CigarettesIndicator(x:Number, y:Number) {
            super(x, y);
            _gfx = new Graphiclist();
            _gfx.scrollX = 0;
            _gfx.scrollY = 0;
            _img = new Image(CIGARETTES_IMAGE);
            _img.x = 20;
            _gfx.add(_img);
            _txt = new Text("");
            _txt.size = 8;
            _txt.color = 0xFFFFFF;
            _txt.field.filters = [new GlowFilter(0x000000, 1, 4, 4)];
            _gfx.add(_txt);
            graphic = _gfx;
        }
        
        public function setCharges(current:int, total:int):void {
            _txt.text = current+"/"+total;
        }
    }
}