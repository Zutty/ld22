package uk.co.zutty.ld22.hud
{
    import flash.filters.GlowFilter;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Text;
    
    public class FullScreenMessage extends Entity {
        
        private var _txt:Text;
        
        public function FullScreenMessage() {
            super(0, 0);
            _txt = new Text("");
            _txt.centerOrigin();
            _txt.size = 24;
            _txt.color = 0xFFFFFF;
            _txt.field.filters = [new GlowFilter(0x000000, 1, 4, 4)];
            _txt.resizable = false;
            _txt.width = FP.width;
            _txt.height = FP.height;
            _txt.align = "center";
            _txt.scrollX = 0;
            _txt.scrollY = 0;
            graphic = _txt;
            hide();
        }
        
        public function show(msg:String):void {
            _txt.text = msg;
            y = (FP.height - _txt.textHeight) / 2;
            active = true;
            visible = true;
        }
        
        public function hide():void {
            active = false;
            visible = false;
        } 
    }
}