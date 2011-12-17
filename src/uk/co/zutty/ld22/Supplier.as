package uk.co.zutty.ld22
{
    import net.flashpunk.Entity;

    public class Supplier {
        
        private static const allSuppliers:Vector.<Supplier> = new Vector.<Supplier>();
        
        private var _poolSize:int;
        private var _callback:Function;
        private var _entities:Vector.<Entity>;
        private var _idx:int;
        
        public static function newSupplier(poolSize:int, callback:Function):Supplier {
            var s:Supplier = new Supplier(poolSize, callback);
            allSuppliers[allSuppliers.length] = s;
            return s;
        }
        
        public static function initAll():void {
            for each(var s:Supplier in allSuppliers) {
                s.init();
            }
        }
        
        public function Supplier(poolSize:int, callback:Function) {
            _poolSize = poolSize;
            _callback = callback;
            _entities = new Vector.<Entity>(poolSize);
        }
        
        public function get entities():Vector.<Entity> {
            return _entities;
        }
        
        public function init():void {
            for(var i:int = 0; i < _poolSize; i++) {
                _entities[i] = _callback();
            }
            _idx = -1;
        }
        
        public function next():Entity {
            _idx = (_idx + 1) % _poolSize;
            return _entities[_idx];
        }
    }
}