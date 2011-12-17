package uk.co.zutty.ld22
{
    import net.flashpunk.Entity;
    import net.flashpunk.World;
    
    import uk.co.zutty.ld22.entities.Baddie;
    import uk.co.zutty.ld22.entities.Player;
    import uk.co.zutty.ld22.levels.Level;
    import uk.co.zutty.ld22.levels.Level1;
    import uk.co.zutty.ld22.levels.OgmoLevel;
    
    public class GameWorld extends World {
        
        private var player:Entity;
        
        public function GameWorld() {
            super();
            
            // Add the sky and ground
            var level1:Level = new Level1();
            add(level1.getLayer("sky"));
            add(level1.getLayer("ground", true));

            // Add the player
            player = new Player();
            player.x = 160;
            player.y = 120;
            add(player);
            
            add(new Baddie(160, 120));
        }
        
        override public function update():void {
            super.update();
        }
    }
}