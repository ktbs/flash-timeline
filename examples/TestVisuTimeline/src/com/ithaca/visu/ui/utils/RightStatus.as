package com.ithaca.visu.ui.utils
{
    public class RightStatus
    {
        public static const CAN_MODIFY_OTHER_SESSION:uint = 12;
        public static const NUMBER_DIGITS_IN_MASK_RIGHT:uint = 20;
        
        public static function hasRight(profilUser:String , rightUser:uint):Boolean
        {
            if( profilUser.charAt(NUMBER_DIGITS_IN_MASK_RIGHT - 1 - rightUser) == '1' )
            {
                return true;
            }else return false;
                
        }

        public static function binaryToNumber(binaryString:String=""):Number{
            var result:Number = 0;
            var nbrChar:int = binaryString.length;
            for(var nChar:int = nbrChar; nChar > 0; nChar--){
                var char:String = binaryString.charAt(nChar-1);
                if(char == '1'){
                    result = result + numberInNumber(nbrChar - nChar);
                }
            }
            return result;
            function numberInNumber(N:int):Number
            {
                var result:Number = 1;    
                if(N==0)return result;
                for(var i:int = 0 ; i < N; i++ )
                {
                    result = result*2;
                }
                return result;
            }
        }
        
        public static function numberToBinary(iNumber:int):String {
            var result :String = "";
            var oNumber : int = iNumber;
            while (iNumber>0) {
                if (iNumber%2) {
                    result = "1"+result;
                } else {
                    result = "0"+result;
                }
                iNumber = Math.floor(iNumber/2);
            }
            // left pad with zeros
            while (result.length<NUMBER_DIGITS_IN_MASK_RIGHT) {
                result = "0"+result;
            }
            return result;
        };
    }
}