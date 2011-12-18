package uk.co.zutty.ld22
{
    import flash.display.Sprite;
    import flash.geom.Point;
    
    import net.flashpunk.Engine;
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    
    import uk.co.zutty.ld22.entities.Banality;
    import uk.co.zutty.ld22.entities.Bleakness;
    import uk.co.zutty.ld22.entities.PowerWord;
    
    public class Main extends Engine {
        
        public static var vector:Vector2D = new Vector2D(0, 0);
        
        public static const banalities:Supplier = Supplier.newSupplier(64, function():Entity { return new Banality() });
        public static const bleaknesses:Supplier = Supplier.newSupplier(64, function():Entity { return new Bleakness() });
        
        public function Main() {
            super(320, 240, 60, false);
            FP.screen.scale = 2;
            FP.screen.color = 0x000000;
            //FP.console.enable();
            
            Supplier.initAll();
            
            FP.world = new GameWorld();
        }
    }
}