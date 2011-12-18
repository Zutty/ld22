package uk.co.zutty.ld22.levels
{
    import flash.geom.Point;
    import flash.utils.ByteArray;
    
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.masks.Grid;
    
    import uk.co.zutty.ld22.Vector2D;
    
    public class OgmoLevel implements Level {
        
        private var data:XML;
        private var tileMaps:Object;
        private var tileWidth:Number;
        private var tileHeight:Number;
        
        public function OgmoLevel(raw:Class, tileMaps:Object, tileWidth:Number, tileHeight:Number) {
            this.tileWidth = tileWidth;
            this.tileHeight = tileHeight;
            this.tileMaps = tileMaps;
            var bytes:ByteArray = new raw();
            data = new XML(bytes.readUTFBytes(bytes.length));
        }
        
        public function get width():Number {
            return data.width;
        }
        
        public function get height():Number {
            return data.height;
        }
        
        public function getLayer(name:String, solid:Boolean = false):Layer {
            return loadLayer(name, true, solid);
        }
        
        public function getMask(name:String):Entity {
            return loadLayer(name, false, true);
        }
        
        private function loadLayer(name:String, showTiles:Boolean, solid:Boolean):Layer {
            var layer:Layer = new Layer();
            
            if(showTiles) {
                layer.tilemap = new Tilemap(tileMaps[name] as Class, data.width, data.height, tileWidth, tileHeight);
            }
            if(solid) {
                layer.grid = new Grid(data.width, data.height, tileWidth, tileHeight);
            }
            
            for each(var tile:XML in data[name][0].tile) {
                if(showTiles) {
                    var idx:uint = layer.tilemap.getIndex(tile.@tx / tileWidth, tile.@ty / tileHeight);
                    layer.tilemap.setTile(tile.@x / tileWidth, tile.@y / tileHeight, idx);
                }
                if(solid) {
                    layer.grid.setTile(tile.@x / tileWidth, tile.@y / tileHeight);
                }
            }
            
            if(solid) {
                layer.type = (showTiles) ? "solid" : name;
            }
            
            return layer;
        }
        /*
        public function getObjectWaypoints(layerName:String, objName:String):Vector.<Waypoint> {
            var ret:Vector.<Waypoint> = new Vector.<Waypoint>();
            for each(var obj:XML in data[layerName][0][objName]) {
                var first:Waypoint = new Waypoint(obj.@x, obj.@y);
                var prev:Waypoint = first;
                
                for each(var node:XML in obj.node) {
                    var wp:Waypoint = new Waypoint(node.@x, node.@y);
                    prev.next = wp;
                    prev = wp;
                }
                prev.next = first;
                ret.push(first);
            }
            return ret;
        }*/
        
        public function getObjectPositions(layerName:String, objName:String):Vector.<Point> {
            var ret:Vector.<Point> = new Vector.<Point>();
            for each(var obj:XML in data[layerName][0][objName]) {
                ret[ret.length] = new Point(obj.@x, obj.@y);
            }
            return ret;
        }
    }
}