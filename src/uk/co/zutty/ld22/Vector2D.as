package uk.co.zutty.ld22
{
    import flash.geom.Point;
    
    import net.flashpunk.FP;

    public class Vector2D {
        
        public var x:Number;
        public var y:Number; 
        
        public function Vector2D(x:Number, y:Number) {
            set(x, y);
        }
        
        public function set(x:Number, y:Number):void {
            this.x = x;
            this.y = y;
        }

        public function setp(p:Point):void {
            x = p.x;
            y = p.y;
        }

        public function setCartesian(ax:Number, ay:Number, bx:Number, by:Number):void {
            x = bx - ax;
            y = by - ay;
        }

        public function setPolar(angle:Number, mag:Number):void {
            x = Math.cos(FP.RAD * -angle) * mag;
            y = Math.sin(FP.RAD * -angle) * mag;
        }
        
        public function get angle():Number {
            return Math.atan2(x, -y) * FP.DEG;                
        }
        
        public function get magnitude():Number {
            return Math.sqrt(x*x + y*y);
        }
        
        public function set magnitude(newMag:Number):void {
            if(newMag == 0) {
                x = 0;
                y = 0;
                return;
            }
            
            var oldMag:Number = magnitude;
            if(oldMag == 0) {
                // We cant do anything in this scenario, so just give up
                return;
            }
            
            var m:Number = newMag/oldMag;
            x *= m;
            y *= m;
        }
        
        public function normalise():void {
            magnitude = 1;
        } 
    }
}