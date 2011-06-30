package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;

	public class Layout
	{
		public static const SPLIT_ON: String = "splitOn";
		public static const SELECTOR: String = "selector";
		
		public var layoutTree : XML = <traceLineGroup> 	
											<tl> 
												<tl selector="selectorRegexp" field="type" regexp="Message" >
													<tl selector="selectorRegexp" field="type" regexp="Send" />
													<tl selector="selectorRegexp" field="type" regexp="Receive" />
												</tl>
												<tl selector="selectorRegexp" field="type" regexp="Document" />
												<tl selector="selectorRegexp" field="type" regexp="Marker" />
												<tl selector="selectorRegexp" field="type" regexp="Instructions" />
												<tl selector="selectorRegexp" field="type" regexp="Keyword" />
												<tl selector="selectorRegexp" field="type" regexp="/*" >
													<tl selector="selectorRegexp" field="type" regexp="^SessionExit$" />
													<tl selector="selectorRegexp" field="type" regexp="/*" />
												</tl>
											</tl>
									 </traceLineGroup>;
		
		private var timeline : Timeline; 
		
		public function Layout( tl : Timeline )
		{
			timeline = tl;
		}
		
		public function splitBy( field : String ) : void 
		{
			
		}
		
		public function obselLocation( obsel : Obsel ) : TraceLine 
		{
			var traceLineGroup : TraceLineGroup = null;
			var newTrace : Boolean = false;
			var traceLine : TraceLine = null;
			
			for each ( var tlgItt : TraceLineGroup in timeline.children )
				if ( tlgItt._trace.uri == obsel.traceUri )
				{
					traceLineGroup = tlgItt;
					break;
				}
				
			if ( traceLineGroup == null )
			{	
				newTrace = true;
				traceLineGroup = createNewTraceLineGroup ( obsel.trace ) as TraceLineGroup;
			}
			
			for each ( var tl : TraceLine in traceLineGroup.children )			
				if ( traceLine = findObselLocation(obsel, tl ) )
					break;			
			
			if ( traceLine )
			{
				if (newTrace)
					timeline.children.addItem( traceLineGroup );
				return traceLine;
			}	
			
			return null;
			
			function findObselLocation( obsel : Obsel, traceLine : TraceLine ) : TraceLine
			{
				if ( traceLine.acceptObsel( obsel ) )
				{
					var tl : TraceLine = null;
					
					for each ( var traceLineChild : TraceLine in traceLine.children )
						if ( tl = findObselLocation(obsel, traceLineChild ) )
							return tl;
					 
					return traceLine;
				}

				return null;
			}
		}
				
		
		public function obselLocations( obsel : Obsel ) : ArrayCollection 
		{
			var traceLineGroup : TraceLineGroup = null;
			var newTrace : Boolean = false;
			var locations : ArrayCollection = new ArrayCollection();
			
			// Search the Tracelinegroup with the same traceUri 
			for each ( var tlgItt : TraceLineGroup in timeline.children )
				if ( tlgItt._trace.uri == obsel.traceUri )
				{
					traceLineGroup = tlgItt;
					break;
				}
			
			// if it doesn't exist we create a tracelinegroup and a traceline tree  
			if ( traceLineGroup == null )
			{	
				newTrace = true;
				traceLineGroup = createNewTraceLineGroup ( obsel.trace ) as TraceLineGroup;
			}
			
			// we browse all the tracelines to find all the possible locations
			for each ( var tl : TraceLine in traceLineGroup.children )			
				findObselLocations(obsel, tl );
							
			
			if ( locations.length > 0 )
			{
				if (newTrace)
					timeline.children.addItem( traceLineGroup );
				return locations;
			}	
			
			return null;
			
			function findObselLocations( obsel : Obsel, traceLine : TraceLine ) : Boolean
			{
				if ( traceLine.acceptObsel( obsel ) )
				{
					locations.addItem(traceLine);
					var tl : TraceLine = null;
					
					for each ( var traceLineChild : TraceLine in traceLine.children )
						 if (findObselLocations(obsel, traceLineChild ) ) 
							 break;
						 
					return true;
				}
				return false;
			}
		}
		
		private function createNewTraceLineGroup ( theTrace : Trace ) : ILayoutNode 
		{
			var newTraceLineGroup : TraceLineGroup = new TraceLineGroup ();
			
			newTraceLineGroup._trace = theTrace;
			
			newTraceLineGroup.layout = layoutTree;
			
			for each ( var selector : XML in layoutTree.children() )
				newTraceLineGroup.children.addItem( createTraceLineTree(selector) ) 
			
			return newTraceLineGroup;
			
			function createTraceLineTree( traceLineTreeXml : XML ) : TraceLine
			{
				var traceLine : TraceLine = new TraceLine();
				traceLine.layout = traceLineTreeXml;
				
				if ( traceLineTreeXml.hasOwnProperty('@selector') )
				{
					if  ( traceLineTreeXml.@selector == "selectorRegexp")
					{
						traceLine.title = "regexp : " + traceLineTreeXml.@regexp;
						traceLine._selector = new selectorRegexp(traceLineTreeXml.@regexp, traceLineTreeXml.@field);
					}
					else
					{
						var selectorClass:Class = getDefinitionByName( traceLineTreeXml.@selector ) as Class;
						traceLine.title = traceLineTreeXml.@selector;
						traceLine._selector = new selectorClass();
					}
				}
				
				if ( traceLineTreeXml.hasOwnProperty('@splitter') )									
					traceLine._splitter =  traceLineTreeXml.@splitter ;
				
				for each ( var selector : XML in traceLineTreeXml.children() )
					traceLine.children.addItem( createTraceLineTree(selector) ) 
				
				return traceLine;
			}
		}		
		
	}
}