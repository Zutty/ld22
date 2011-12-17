package uk.co.zutty.ld22
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    
    import uk.co.zutty.ld22.entities.Baddie;
    import uk.co.zutty.ld22.entities.Bystander;
    import uk.co.zutty.ld22.entities.Player;
    import uk.co.zutty.ld22.hud.DamageBar;
    import uk.co.zutty.ld22.hud.FullScreenMessage;
    import uk.co.zutty.ld22.levels.Level;
    import uk.co.zutty.ld22.levels.Level1;
    import uk.co.zutty.ld22.levels.OgmoLevel;
    
    public class GameWorld extends World {
        
        public static const RESPAWN_TICKS:int = 80;
        
        private var player:Player;
        private var failMsg:FullScreenMessage;
        private var damageBar:DamageBar;
        private var respawnTick:int;
        
        public function GameWorld() {
            super();
            
            // Add the sky and ground
            var level1:Level = new Level1();
            add(level1.getLayer("sky"));
            add(level1.getLayer("ground", true));

            // Add the player
            player = new Player();
            add(player);
            
            // Draw bystanders
            var bystander:Bystander = new Bystander(200, 80);
            bystander.target = player;
            add(bystander);
            
            // Add all banalities
            for each(var b:Entity in Main.banalities.entities) {
                add(b);
            }

            // Draw baddies            
            add(new Baddie(160, 180));

            // Draw the HUD over everything
            damageBar = new DamageBar(20, 220);
            add(damageBar);
            
            failMsg = new FullScreenMessage();
            add(failMsg);

            // Start
            spawn();
        }
        
        public function spawn():void {
            player.spawn();
            player.x = 160;
            player.y = 120;
            respawnTick = 0;
            failMsg.hide();
        }
        
        public function die(falling:Boolean):void {
            player.die();
            respawnTick = RESPAWN_TICKS;
            failMsg.show(falling ? "You fell into\nthe unknown" : "You succumbed\nto doubt");
        }
        
        override public function update():void {
            damageBar.value = player.damage / Player.MAX_DAMAGE;
            FP.camera.x = FP.clamp(player.x - 160, 0, 1200-320);
            FP.camera.y = FP.clamp(player.y - 120, 0, 300-240);
            
            if(player.dead && --respawnTick <= 0) {
                spawn();
            }
            
            if(!player.dead && (player.y > 300 || player.damage >= Player.MAX_DAMAGE)) {
                die(player.y > 300);
            }
            
            super.update();
        }
    }
}