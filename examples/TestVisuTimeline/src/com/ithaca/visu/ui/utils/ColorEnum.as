/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 *
 * <ithaca@liris.cnrs.fr>
 *
 * This file is part of Visu.
 *
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 *
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation;
 *   either version 3 of the License, or any later version.
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 *
 * -- GNU LGPL license
 *
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 *
 * -- CeCILL-C license
 *
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use,
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info".
 *
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability.
 *
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or
 * data to be ensured and,  more generally, to use and operate it in the
 * same conditions as regards security.
 *
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 *
 * -- End of licenses
 */
package com.ithaca.visu.ui.utils
{
    public class ColorEnum
    {
        // color for user was out the session
        static public var VOID : String = "0xebcbd2";
        static public var YELLOW : String = "0xefed44";
        static public var BLUE : String = "0xcedbef";
        static public var RED : String = "0xf4b1b1";
        static public var GREEN : String = "0x8df82f";
        static public var VIOLET : String = "0xef96f5";
        static public var BLUEMARIN : String = "0xbdf7f6";
        static public var VOID1 : String = "0xcff795";
        static public var VOID2 : String = "0xf5cb66";
        static public var VOID3 : String = "0x6f7bea";
        static public var VOID4 : String = "0xd879f0";
        static public var VOID5 : String = "0xebcbd2";
        
        public static function getColorByCode(code:String):String
        {
            var color:String = "0xffffff";
            switch (code)
            {
                case "0" :
                    color = VOID;
                    break;
                case "1" :
                    color = YELLOW;
                    break;
                case "2" :
                    color = BLUE;
                    break;
                case "3" :
                    color = RED;
                    break;
                case "4" :
                    color = GREEN;
                    break;
                case "5" :
                    color = VIOLET;
                    break;
                case "6" :
                    color = BLUEMARIN;
                    break;
                case "7" :
                    color = VOID1;
                    break;
                case "8" :
                    color = VOID2;
                    break;
                case "9" :
                    color = VOID3;
                    break;
                case "10" :
                    color = VOID4;
                    break;
                case "11" :
                    color = VOID5;
                    break;
                default :
                    break;                
            }
            return color;
        }
            
    }
}