package uk.co.zutty.ld22.worlds
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Sfx;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    
    import uk.co.zutty.ld22.Main;
    import uk.co.zutty.ld22.Supplier;
    import uk.co.zutty.ld22.entities.Baddie;
    import uk.co.zutty.ld22.entities.Banality;
    import uk.co.zutty.ld22.entities.Bleakness;
    import uk.co.zutty.ld22.entities.Bystander;
    import uk.co.zutty.ld22.entities.Cigarette;
    import uk.co.zutty.ld22.entities.Cloud;
    import uk.co.zutty.ld22.entities.Manuscript;
    import uk.co.zutty.ld22.entities.Player;
    import uk.co.zutty.ld22.entities.Speaker;
    import uk.co.zutty.ld22.hud.CigarettesIndicator;
    import uk.co.zutty.ld22.hud.DamageBar;
    import uk.co.zutty.ld22.hud.FullScreenMessage;
    import uk.co.zutty.ld22.hud.LivesIndicator;
    import uk.co.zutty.ld22.levels.Layer;
    import uk.co.zutty.ld22.levels.Level;
    import uk.co.zutty.ld22.levels.Level1;
    import uk.co.zutty.ld22.levels.OgmoLevel;
    
    public class GameWorld extends World {
        
        public static const RESPAWN_TICKS:int = 80;
        
        [Embed(source = 'assets/crisis.mp3')]
        private const CRISIS_SOUND:Class;
        [Embed(source = 'assets/fall.mp3')]
        private const FALL_SOUND:Class;
        [Embed(source = 'assets/music2.mp3')]
        private const MUSIC2_SOUND:Class;

        public const banalities:Supplier = new Supplier(64, function():Entity { return new Banality() });
        public const bleaknesses:Supplier = new Supplier(64, function():Entity { return new Bleakness() });
        public const clouds:Supplier = new Supplier(16, function():Entity { return new Cloud() });

        private var player:Player;
        private var _spawnPoint:Point;
        private var failMsg:FullScreenMessage;
        private var fagsInd:CigarettesIndicator;
        private var livesInd:LivesIndicator;
        private var damageBar:DamageBar;
        private var respawnTick:int;
        
        private var _level:Level;
        private var happySky:Layer;
        private var happyGround:Layer;
        private var happyOverlay:Layer;
        private var sadSky:Layer;
        private var sadGround:Layer;
        private var sadOverlay:Layer;
        private var _lives:int; 
        private var _won:Boolean;
        private var _winTick:int;
        
        private var _fallSfx:Sfx;
        private var _crisisSfx:Sfx;
        private var _musicSfx:Sfx;

        public function GameWorld(l:int) {
            super();
            
            // Init suppliers
            banalities.init();
            bleaknesses.init();
            clouds.init();
            
            // Init generic shite
            _lives = 3;
            _won = false;
            _winTick = 0;

            // Sfx
            _fallSfx = new Sfx(FALL_SOUND);
            _crisisSfx = new Sfx(CRISIS_SOUND);
            _musicSfx = new Sfx(MUSIC2_SOUND);
            _musicSfx.loop();
            Main.handleMute(_musicSfx);
            
            var lev:Level;
            if(l == 1) {
                lev = new Level1();
            }
            loadLevel(lev);

            // Add all power words (i.e. bullets)
            for each(var b:Entity in banalities.entities) {
                add(b);
            }
            for each(var bl:Entity in bleaknesses.entities) {
                add(bl);
            }
            for each(var c:Entity in clouds.entities) {
                add(c);
            }
            
            // Draw the HUD over everything
            damageBar = new DamageBar(40, 225);
            add(damageBar);
            fagsInd = new CigarettesIndicator(280, 225);
            add(fagsInd);
            livesInd = new LivesIndicator(5, 225);
            add(livesInd);
            failMsg = new FullScreenMessage();
            add(failMsg);

            // Start
            balanceLayers();
            spawn();
            fagsInd.setCharges(player.healCharges, Player.HEAL_MAX_CHARGES);
            livesInd.setLives(_lives);
        }
        
        public function loadLevel(lvl:Level):void {    
            // Add the sky and ground
            _level = lvl;
            happySky = _level.getLayer("sky");
            sadSky = _level.getLayer("sad_sky");
            sadSky.sad = true;
            add(happySky);
            add(sadSky);

            happyGround = _level.getLayer("ground", true);
            sadGround = _level.getLayer("sad_ground", true);
            sadGround.sad = true;
            add(happyGround);
            add(sadGround);
            
            // Add all powerups
            var p:Point;
            for each(p in _level.getObjectPositions("objects", "manuscript")) {
                add(new Manuscript(p.x + 8, p.y + 8));
            }
            for each(p in _level.getObjectPositions("objects", "cigarette")) {
                add(new Cigarette(p.x + 8, p.y + 8));
            }
            
            // Add the player
            player = new Player();
            player.onTrapped = dieTrapped;
            add(player);
            for each(p in _level.getObjectPositions("objects", "spawn")) {
                _spawnPoint = new Point(p.x + 8, p.y + 16);
            }
            
            // Draw bystanders
            for each(p in _level.getObjectPositions("objects", "bystander")) {
                var bystander:Bystander = new Bystander(p.x + 8, p.y + 16);
                bystander.target = player;
                add(bystander);
            }
            
            happyOverlay = _level.getLayer("overlay");
            sadOverlay = _level.getLayer("sad_overlay");
            sadOverlay.sad = true;
            add(happyOverlay);
            add(sadOverlay);

            // Draw baddies   
            for each(p in _level.getObjectPositions("baddies", "turmoil")) {
                add(new Baddie(p.x + 12, p.y + 12));
            }
        }
        
        public function get level():Level {
            return _level;
        }
        
        public function spawn():void {
            player.spawn();
            player.x = _spawnPoint.x;
            player.y = _spawnPoint.y;
            respawnTick = 0;
            failMsg.hide();
        }
        
        public function dieTrapped():void {
            _crisisSfx.play();
            die("You fell victim\nto absurdity");
        }
        
        public function die(msg:String):void {
            player.die();
            respawnTick = RESPAWN_TICKS;
            _lives--;
            livesInd.setLives(_lives);
            
            if(_lives <= 0) {
                failMsg.show("GAME OVER");
            } else {
                failMsg.show(msg);
            }
        }
        
        public function win():void {
            failMsg.show("You done won");
            player.active = false;
            _won = true;
            _winTick = 100;
        }
        
        public function balanceLayers():void {
            var balance:Number = tween(player.damagePct, 0.3, 0.7);
            
            happySky.tilemap.alpha = 1 - balance;
            happyGround.tilemap.alpha = Math.max(1 - balance, 0.1);
            happyOverlay.tilemap.alpha = Math.max(1 - balance, 0.1);
            
            sadSky.tilemap.alpha = balance;
            sadGround.tilemap.alpha = balance;
            sadOverlay.tilemap.alpha = balance;
            
            // Set collidableness
            happyGround.collidable = player.damagePct < 0.65; 
            sadGround.collidable = player.damagePct > 0.35; 
        }
        
        public function get sadAlpha():Number {
            return tween(player.damagePct, 0.3, 0.7);
        }
        
        private function tween(n:Number, l:Number, u:Number):Number {
            var e:Number = u - l;
            return n < l ? 0 : n > u ? 1 : (n - l) / e;
        }
        
        override public function update():void {
            balanceLayers();
            
            if(Input.pressed(Key.M)) {
                Main.toggleMute();
                Main.handleMute(_musicSfx);
            }
            
            if(_won && --_winTick <= 0) {
                _musicSfx.stop();
                Main.nextLevel();
            }
            
            damageBar.value = player.damagePct;
            FP.camera.x = FP.clamp(player.x - 160, 0, _level.width-320-16); // Cut off one tile early
            FP.camera.y = FP.clamp(player.y - 120, 0, _level.height-240);
            
            if(player.dead && --respawnTick <= 0) {
                if(_lives <= 0) {
                    _musicSfx.stop();
                    Main.goToTitleScreen();
                } else {
                    spawn();
                }
            }
            
            var fell:Boolean = player.y > level.height;
            if(!player.dead && (fell || player.damage >= player.maxDamage)) {
                (fell ? _fallSfx : _crisisSfx).play();
                die(fell ? "You fell into\nthe unknown" : "You succumbed\nto doubt");
            }
            fagsInd.setCharges(player.healCharges, Player.HEAL_MAX_CHARGES);
            
            if(player.x > _level.width - 16 && !_won) {
                if(!player.isPoweredUp) {
                    player.message = "Collect the manuscript";
                } else {
                    win();
                }
            }
            
            super.update();
        }
    }
}