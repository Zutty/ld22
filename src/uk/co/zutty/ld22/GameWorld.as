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
    import uk.co.zutty.ld22.levels.Layer;
    import uk.co.zutty.ld22.levels.Level;
    import uk.co.zutty.ld22.levels.Level1;
    import uk.co.zutty.ld22.levels.OgmoLevel;
    
    public class GameWorld extends World {
        
        public static const RESPAWN_TICKS:int = 80;
        
        private var player:Player;
        private var failMsg:FullScreenMessage;
        private var damageBar:DamageBar;
        private var respawnTick:int;
        
        private var happySky:Layer;
        private var happyGround:Layer;
        private var sadSky:Layer;
        private var sadGround:Layer;
        
        public function GameWorld() {
            super();
            
            // Add the sky and ground
            var level1:Level = new Level1();
            happySky = level1.getLayer("sky");
            happyGround = level1.getLayer("ground", true);
            add(happySky);
            add(happyGround);

            sadSky = level1.getLayer("sad_sky");
            sadGround = level1.getLayer("sad_ground", true);
            sadSky.sad = true;
            sadGround.sad = true;
            add(sadSky);
            add(sadGround);
            
            // Add the player
            player = new Player();
            player.onTrapped = dieTrapped;
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
            balanceLayers();
            spawn();
        }
        
        public function spawn():void {
            player.spawn();
            player.x = 160;
            player.y = 120;
            respawnTick = 0;
            failMsg.hide();
        }
        
        public function dieTrapped():void {
            die("You fell victim\nto absurdity");
        }
        
        public function die(msg:String):void {
            player.die();
            respawnTick = RESPAWN_TICKS;
            failMsg.show(msg);
        }
        
        public function balanceLayers():void {
            var balance:Number = player.damagePct;
            happySky.tilemap.alpha = 1 - tween(balance, 0.3, 0.7);
            happyGround.tilemap.alpha = 1 - tween(balance, 0.3, 0.7);
            
            sadSky.tilemap.alpha = tween(balance, 0.3, 0.7);
            sadGround.tilemap.alpha = tween(balance, 0.3, 0.7);
            
            // Set collidableness
            happyGround.collidable = player.damagePct < 0.65; 
            sadGround.collidable = player.damagePct > 0.35; 
        }
        
        private function tween(n:Number, l:Number, u:Number):Number {
            var e:Number = u - l;
            return n < l ? 0 : n > u ? 1 : (n - l) / e;
        }
        
        override public function update():void {
            balanceLayers();
            
            damageBar.value = player.damagePct;
            FP.camera.x = FP.clamp(player.x - 160, 0, 1200-320);
            FP.camera.y = FP.clamp(player.y - 120, 0, 300-240);
            
            if(player.dead && --respawnTick <= 0) {
                spawn();
            }
            
            if(!player.dead && (player.y > 300 || player.damage >= player.maxDamage)) {
                die(player.y > 300 ? "You fell into\nthe unknown" : "You succumbed\nto doubt");
            }
            
            super.update();
        }
    }
}