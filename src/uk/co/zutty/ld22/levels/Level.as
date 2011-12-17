package uk.co.zutty.ld22.levels
{
    import net.flashpunk.Entity;

    public interface Level {
        function get width():Number;
        function get height():Number;
        function getLayer(name:String, solid:Boolean = false):Entity;
        function getMask(name:String):Entity;
    }
}