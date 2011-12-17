package uk.co.zutty.ld22
{
    import net.flashpunk.Entity;
    import net.flashpunk.World;
    
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
        }
        
        override public function update():void {
            super.update();
        }
    }
}