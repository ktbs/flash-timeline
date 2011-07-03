package com.ithaca.Timeline
{
	import com.ithaca.traces.Obsel;
	import com.ithaca.traces.Trace;
	
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;

	public class Layout
	{
		public static const TRACELINEGROUP: String = "tlg";
		public static const TRACELINE: String = "tl";
		
		public var layoutTree : XML = <tlg> 	
											<tl> 
		 										<tl selector="selectorRegexp" field="type" regexp="Message" filter="false">
													<tl selector="selectorRegexp" field="type" regexp="Send" />
													<tl selector="selectorRegexp" field="type" regexp="Receive" />
													<tl selector="selectorRegexp" field="type" regexp="Document" />
												</tl>
												<tl selector="selectorRegexp" field="type" regexp="Document" />
												<tl selector="selectorRegexp" field="type" regexp="Marker" />
												<tl selector="selectorRegexp" field="type" regexp="Instructions" />
												<tl selector="selectorRegexp" field="type" regexp="Keyword" />
												<tl splitter="type" />																							
											</tl>
									 </tlg>;
		
		public var layoutTree1 : XML = <root>
											<spliter class="ByField" param="traceUri" >
												<tl > 
													<tl selector="selectorRegexp" field="type" regexp="Message" >
														<tl selector="selectorRegexp" field="type" regexp="Send" />
														<tl selector="selectorRegexp" field="type" regexp="Receive" />
														<tl selector="selectorRegexp" field="type" regexp="Document" />
													</tl>
													<tl selector="selectorRegexp" field="type" regexp="Document" />
													<tl selector="selectorRegexp" field="type" regexp="Marker" />
													<tl selector="selectorRegexp" field="type" regexp="Instructions" />
													<tl selector="selectorRegexp" field="type" regexp="Keyword" />	
													<tl>
														<spliter class="ByField" param="type" />
													</tl>
												</tl>
											</spliter>
										 </root>;
		
		private var timeline : Timeline; 
		
		public function Layout( tl : Timeline )
		{
			timeline = tl;
		}
		
		public function findLocations( obsel : Obsel  ) : ArrayCollection 
		{
			var locations : ArrayCollection = new ArrayCollection();
			
			if ( findObselLocations(obsel, timeline._Root ) )
				return locations;
		
			return null;
			
			function findObselLocations( obsel : Obsel, node : LayoutNode  ) : Boolean
			{
				var obselMatches : Boolean = false ;
				var childAccept : Boolean = false;
				
				if ( node.value is TraceLineGroup && (node.value as TraceLineGroup).traceUri != obsel.traceUri )
					return false;
								
				if ( node.value is TraceLine && (node.value as TraceLine).acceptObsel( obsel ) ) 
				{
					obselMatches = true;
					locations.addItem( node.value );
				}
				
				if ( !node.filter || obselMatches == true ) 
					{
					for each ( var child : LayoutNode in node.children )
						if (findObselLocations(obsel, child ) )
						{						
							childAccept = true;
						//	break;	
						}
					}
				
				if ( !childAccept && node.splitBy() )
				{
					var  newNode : LayoutNode = createTree(  obsel, node.layout );
					node.addChild( newNode );
					if ( newNode.value is TraceLine )
					{			
					//	newNode._splitter = null;
						(newNode.value as TraceLine).title  =  "regexp : " + "^"+ obsel[node.splitBy()] +"$";
						(newNode.value as TraceLine)._selector =  new selectorRegexp( "^"+ obsel[node.splitBy()] +"$" , node.splitBy() );
					} 						
					
					childAccept = true;
					findObselLocations(obsel, newNode );						
				}
				
				return obselMatches || childAccept;
			}
		}
		
		
		private function createTree ( obsel : Obsel, xmlLayout : XML ) : LayoutNode 
		{
			var newNode : LayoutNode;
			
			switch( xmlLayout.localName() )
			{
				case TRACELINEGROUP :
				{
					newNode = new LayoutNode();
					newNode.layout = xmlLayout;
					
					newNode.value =  new TraceLineGroup ();
					(newNode.value  as TraceLineGroup)._trace = obsel.trace;
					
					break;
				}
				case TRACELINE :	
				{
					newNode = new LayoutNode();				
					newNode.layout = xmlLayout;
					newNode.value = new TraceLine();
					
					if ( xmlLayout.hasOwnProperty('@selector') )
					{
						if  ( xmlLayout.@selector == "selectorRegexp")
						{
							(newNode.value as TraceLine).title = "regexp : " + xmlLayout.@regexp;
							(newNode.value as TraceLine)._selector = new selectorRegexp(xmlLayout.@regexp, xmlLayout.@field);
						}
						else
						{
							var selectorClass:Class = getDefinitionByName( xmlLayout.@selector ) as Class;
							(newNode.value as TraceLine).title = xmlLayout.@selector;							
							(newNode.value as TraceLine)._selector = new selectorClass();
						}
					}
					
					if ( xmlLayout.hasOwnProperty('@filter') )					
						newNode.filter =  ( xmlLayout.@filter == "true") ;					
					
					if ( xmlLayout.hasOwnProperty('@splitter') )									
						newNode._splitter =  xmlLayout.@splitter ;
					break;
				}			
			}
			
			for each ( var child : XML in xmlLayout.children() )
				newNode.addChild( createTree( obsel, child ) )
			
			return newNode;
		}		
	}
}