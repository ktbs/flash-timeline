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
package com.ithaca.visu.model
{
    public class ActivityElementType
    {
        public static const MEMO         : String = "memo";
        public static const KEYWORD     : String = "keyword";
        public static const STATEMENT     : String = "consigne";
        public static const IMAGE         : String = "image";
        public static const VIDEO         : String = "video";
        public static const MESSAGE     : String = "chatMessage";
        public static const MARKER         : String = "marker";
        public static const READ_DOCUMENT_IMAGE : String = "readDocumentImage";
        public static const READ_DOCUMENT_VIDEO : String = "readDocumentVideo";
        public static const START_ACTIVITY : String = "startActivity";
        public static const STOP_ACTIVITY : String = "stopActivity";
        
        protected var value:int;
        protected var name:String;
        public static function getStringOfType(type:int):String
        {
            switch (type)
            {
                case 1:
                    return ActivityElementType.STATEMENT;
                    break;
                case 2:
                    return ActivityElementType.KEYWORD;
                    break;
                case 3:
                    return ActivityElementType.IMAGE;
                    break;
                case 4:
                    return ActivityElementType.VIDEO;
                    break;
                case 5:
                    return ActivityElementType.MESSAGE;
                    break;
                case 6:
                    return ActivityElementType.MARKER;
                    break;
                case 7:
                    return ActivityElementType.READ_DOCUMENT_IMAGE;
                    break;
                case 8:
                    return ActivityElementType.READ_DOCUMENT_VIDEO;
                    break;
                case 9:
                    return ActivityElementType.START_ACTIVITY;
                    break;
                case 10:
                    return ActivityElementType.STOP_ACTIVITY;
                    break;
                default:
                    return "void";
                    break;
            }
        }
        
        public static function valueOf(value:String):int
        {
            switch (value)
            {
                case ActivityElementType.STATEMENT:
                    return 1;
                    break;
                case ActivityElementType.KEYWORD:
                    return 2;
                    break;
                case ActivityElementType.IMAGE:
                    return 3;
                    break;
                case ActivityElementType.VIDEO:
                    return 4;
                    break;
                case ActivityElementType.MESSAGE:
                    return 5;
                    break;
                case ActivityElementType.MARKER:
                    return 6;
                    break;
                case ActivityElementType.READ_DOCUMENT_IMAGE:
                    return 7;
                    break;
                case ActivityElementType.READ_DOCUMENT_VIDEO:
                    return 8;
                    break;
                case ActivityElementType.START_ACTIVITY:
                    return 9;
                    break;
                case ActivityElementType.STOP_ACTIVITY:
                    return 10;
                    break;
                default:
                    return -1;
                    break;
            }
        }
    }
}