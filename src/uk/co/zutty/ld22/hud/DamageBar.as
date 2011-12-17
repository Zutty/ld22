package uk.co.zutty.ld22.hud
{
    import flash.filters.GlowFilter;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    
    import uk.co.zutty.ld22.Util;
    import uk.co.zutty.ld22.entities.Player;
    
    public class DamageBar extends Entity {
        
        private static var LOW_DMG_COLOUR:uint = 0x00FF00;
        private static var HIGH_DMG_COLOUR:uint = 0xFF0000;
        
        private var _bar:Image;
        private var _gfx:Graphiclist;
        
        public function DamageBar(x:Number, y:Number) {
            super(x, y);
            
            _gfx = new Graphiclist();
            graphic = _gfx;

            // The text
            var txt:Text = new Text("Doubt");
            txt.y = -2;
            txt.color = 0xFFFFFF;
            txt.field.filters = [new GlowFilter(0x000000, 1, 4, 4)];
            txt.size = 8;
            _gfx.add(txt);
            
            // the bar background
            var bg:Image = Image.createRect(202, 7, 0x000000);
            bg.originX = -30;
            _gfx.add(bg);

            // The bar itself
            _bar = Image.createRect(200, 5, 0xFFFFFF);
            _bar.scrollX = 0;
            _bar.scrollY = 0;
            _bar.originX = -31;
            _bar.originY = -1;
            _bar.clipRect.width = 200; 
            _gfx.add(_bar);
        }
        
        public function set value(v:Number):void {
            var val:Number = FP.clamp(v, 0, 1);
            _bar.clipRect.width = v * 200;
            
            _bar.color = Util.interpolateColors(LOW_DMG_COLOUR, HIGH_DMG_COLOUR, v);
            _bar.updateBuffer(true);
        }
    }
}