package uk.co.zutty.ld22
{
    public class Util {
        // Taken from StackOverflow.com, answer by Quasimondo (http://stackoverflow.com/questions/2630925)
        public static function interpolateColors( a:int, b:int, lerp:Number ):int { 
            var MASK1:int = 0xff00ff; 
            var MASK2:int = 0x00ff00; 
            
            var f2:int = 256 * lerp;
            var f1:int = 256 - f2;
            
            return ((((( a & MASK1 ) * f1 ) + ( ( b & MASK1 ) * f2 )) >> 8 ) & MASK1 ) 
                 | ((((( a & MASK2 ) * f1 ) + ( ( b & MASK2 ) * f2 )) >> 8 ) & MASK2 );
        } 
        /*
        public static function tween(n:Number, ):Number {
            
        }*/
    }
}