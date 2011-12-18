package uk.co.zutty.ld22.levels
{
    import flash.geom.Point;
    
    import net.flashpunk.Entity;

    public interface Level {
        function get width():Number;
        function get height():Number;
        function getLayer(name:String, solid:Boolean = false):Layer;
        function getMask(name:String):Entity;
        function getObjectPositions(layerName:String, objName:String):Vector.<Point>;
    }
}