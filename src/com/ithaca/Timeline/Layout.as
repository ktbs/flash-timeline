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
		public static const TRACELINEGROUP: String = "tlg";
		public static const TRACELINE: String = "tl";
		
		public var layoutTree : XML = <tlg> 	
											<tl> 
												<tl selector="selectorRegexp" field="type" regexp="Message" >
													<tl selector="selectorRegexp" field="type" regexp="Send" />
													<tl selector="selectorRegexp" field="type" regexp="Receive" />
												</tl>
												<tl selector="selectorRegexp" field="type" regexp="Document" />
												<tl selector="selectorRegexp" field="type" regexp="Marker" />
												<tl selector="selectorRegexp" field="type" regexp="Instructions" />
												<tl selector="selectorRegexp" field="type" regexp="Keyword" />
												<tl splitter="type" />																							
											</tl>
									 </tlg>;
		
		private var timeline : Timeline; 
		
		public function Layout( tl : Timeline )
		{
			timeline = tl;
		}
		
		public function findLocations( obsel : Obsel  ) : ArrayCollection 
		{
			var locations : ArrayCollection = new ArrayCollection();
			
			if ( findObselLocations(obsel, timeline ) )
				return locations;
		
			return null;
			
			function findObselLocations( obsel : Obsel, node : ILayoutNode  ) : Boolean
			{
				if ( node.acceptObsel( obsel ) )
				{
					if ( node is TraceLine ) 
						locations.addItem( node );
					
					var childAccept : Boolean = false;
					for each ( var child : ILayoutNode in node.children )
						if (findObselLocations(obsel, child ) )
						{
							childAccept = true;
							break;	
						}
					
					if (!childAccept && node.splitBy() )
					{
						var  newNode : ILayoutNode = createTree(  obsel, node.layout );
						node.children.addItem( newNode );
						if ( newNode is TraceLine )
						{
							(newNode as TraceLine)._splitter = "";
							(newNode as TraceLine)._selector =  new selectorRegexp( "^"+ obsel[node.splitBy()] +"$" , node.splitBy() );
						} 						
						
						findObselLocations(obsel, newNode );						
					}
					return true;
				}
				
				return false;
			}
		}
		
		
		private function createTree ( obsel : Obsel, xmlLayout : XML ) : ILayoutNode 
		{
			var newNode : ILayoutNode;
			
			switch( xmlLayout.localName() )
			{
				case TRACELINEGROUP :
				{
					newNode = new TraceLineGroup ();
					(newNode as TraceLineGroup)._trace = obsel.trace;
					newNode.layout = xmlLayout;
					break;
				}
				case TRACELINE :	
				{
					newNode = new TraceLine();
					newNode.layout = xmlLayout;
					
					if ( xmlLayout.hasOwnProperty('@selector') )
					{
						if  ( xmlLayout.@selector == "selectorRegexp")
						{
							(newNode as TraceLine).title = "regexp : " + xmlLayout.@regexp;
							(newNode as TraceLine)._selector = new selectorRegexp(xmlLayout.@regexp, xmlLayout.@field);
						}
						else
						{
							var selectorClass:Class = getDefinitionByName( xmlLayout.@selector ) as Class;
							(newNode as TraceLine).title = xmlLayout.@selector;
							(newNode as TraceLine)._selector = new selectorClass();
						}
					}
					
					if ( xmlLayout.hasOwnProperty('@splitter') )									
						(newNode as TraceLine)._splitter =  xmlLayout.@splitter ;
					break;
				}			
			}
			
			for each ( var child : XML in xmlLayout.children() )
				newNode.children.addItem( createTree( obsel, child ) )
			
			return newNode;
		}		
	}
}