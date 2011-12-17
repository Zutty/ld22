package uk.co.zutty.ld22
{
    import net.flashpunk.Entity;
    import net.flashpunk.World;
    
    import uk.co.zutty.ld22.entities.Baddie;
    import uk.co.zutty.ld22.entities.Player;
    
    public class GameWorld extends World {
        
        private var player:Entity;
        private var platform:Entity;
        
        public function GameWorld() {
            super();
            player = new Player();
            player.x = 160;
            player.y = 120;
            add(player);
            platform = new Entity();
            
            add(new Baddie(160, 120));
        }
        
        override public function update():void {
            super.update();
        }
    }
}