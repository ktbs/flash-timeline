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
package com.ithaca.traces
{
	/* For remoting */
   
    import flash.events.EventDispatcher;
    
    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    import mx.logging.Log;
    import mx.rpc.remoting.RemoteObject;

    /**
     * Usage:
     * since the class is a singleton (common cairngorm idiocy^H^Hm)
     * we provide a helper static method, thus usage becomes:
     * - at application start, initialize the trace with the uid and possibly the URI:
     *   trace = new Trace(uri='http:...', uid=loggedUser.id);
     * - to log an Obsel:
     *   import com.ithaca.traces.Trace;
     *   Trace.trace("PresenceStart", { email: loggedUser.mail, surname: loggedUser.firstname, name: loggedUser.lastName });

     *
     */
    [Bindable]
    public class Trace extends EventDispatcher
    {
        /**
         * Defines the Singleton instance of the Trace
         */
        private static var instance: Trace;

        /**
         * Shared RemoteObject
         */
        public static var traceRemoteObject: RemoteObject;

        private static var logger:ILogger = Log.getLogger("com.ithaca.traces.Trace");

        public var uri: String = "";
        public var uid: int = 0;

        public var obsels: ArrayCollection;
        /* If True, automatically synchronize with the KTBS */
        public var autosync: Boolean = true;

		public function twoDigits(n: int): String
		{
			if (n < 10)
				return "0" + n.toString();
			else
				return n.toString();
		}

        public function Trace(uid: int = 0, uri: String = ""): void
        {
			var d: Date = new Date();
			// FIXME: debug for the moment (since KTBS is not used):
			if (uri == "")
				uri = "trace-" + d.fullYear + twoDigits(d.month + 1) + twoDigits(d.date) + twoDigits(d.hours) + twoDigits(d.minutes) + twoDigits(d.seconds) + "-" + uid;
            this.uri = uri;
            this.uid = uid;
            this.obsels = new ArrayCollection()
        }

		public static function init_remote(server: String): void
		{
			// Initialise RemoteObject
			traceRemoteObject = new RemoteObject();
			traceRemoteObject.endpoint=server;
			traceRemoteObject.destination = "ObselService";
			traceRemoteObject.makeObjectsBindable=true;
			traceRemoteObject.showBusyCursor=false;
		} 

        public function get remote(): RemoteObject
        {
            return traceRemoteObject;
        }

        public function addObsel(obsel: Obsel): Obsel
        {
            if (obsel.uid == 0)
                obsel.uid = this.uid;
      
            obsel.trace = this;

            this.obsels.addItem(obsel);

            if (this.autosync)
            {
                obsel.toSGBD();
            }
            return obsel;
        }
        public function delObsel(obsel :Obsel):void
        {
        	obsel.trace = this;
        	if(this.autosync)
        	{
	        	obsel.deleteObselSGBD();
        	}
        }
        public function updObsel(obsel:Obsel):void
        {
        	obsel.trace = this;

        	if(this.autosync)
        	{
	        	obsel.updateObselSGBD();
        	}
        }

        /**
         * Return the set of obsels matching type.
         */
        public function filter(type: String): ArrayCollection
        {
            var result: ArrayCollection = new ArrayCollection();

            for each (var obs: Obsel in this.obsels)
            {
                if (obs.type == type)
                {
                    result.addItem(obs);
                }
            }
            return result;
        }

		override public function toString(): String
		{
			return "Trace with " + this.obsels.length + " element(s)";
		}

        /**
         * Returns the Singleton instance of the Trace
         */
        public static function getInstance(uid: int = 0, uri: String = "") : Trace
        {
            if (instance == null)
            {
                instance = new Trace(uid, uri);
            }
            return instance;
        }

        /**
         * Convenience static method to quickly create an Obsel and
         * add it to the trace (singleton).
         */
        public static function trace(type: String, props: Object = null): Obsel
        {
            var o: Obsel;

            try
            {
                o = new Obsel(type, instance.uid, props);
                instance.addObsel(o);
                
                logger.debug("\n===\n" + o.toRDF() + "\n===\n");
            }
			catch (error:Error)
			{
				logger.debug("Exception in trace: " + error);
			}
            return o;
        }

    }

}
