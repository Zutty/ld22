package uk.co.zutty.ld22
{
    import net.flashpunk.Entity;
    import net.flashpunk.Sfx;

    public class SfxSupplier {
        
        private var _poolSize:int;
        private var _sound:Class;
        private var _pool:Vector.<Sfx>;
        private var _idx:int;
        
        public function SfxSupplier(poolSize:int, sound:Class) {
            _poolSize = poolSize;
            _sound = sound;
            _pool = new Vector.<Sfx>(poolSize);
        }
        
        public function init():void {
            for(var i:int = 0; i < _poolSize; i++) {
                _pool[i] = new Sfx(_sound);
            }
            _idx = -1;
        }
        
        public function next():Sfx {
            _idx = (_idx + 1) % _poolSize;
            return _pool[_idx];
        }
    }
}