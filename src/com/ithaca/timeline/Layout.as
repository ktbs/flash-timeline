package com.ithaca.timeline
{
	import com.ithaca.traces.Trace;
	import flash.utils.getDefinitionByName;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;	
	import spark.components.Button;
	
	public class Layout
	{
		public static const TRACELINEGROUP: String = "tlg";
		public static const TRACELINE: String = "tl";
		public static const MODIFIER: String = "modifier";
		public static const ROOT: String = "root";

		private var 	_Root 		: LayoutNode = null; 	
		
		public function Layout( tl : Timeline, xmlLayout : XML = null )
		{			
			_Root = new LayoutNode();
			_Root.layout = xmlLayout;
			_Root.value = tl;			
		}
		
		
		public function get tracelineGroups() : ArrayCollection { return _Root.children; }
		
		public function addTracelineGroupTree (  node : LayoutNode,  index : int = -1) : void
		{
			if ( node )		
				_Root.addChild(  node , index );			
		}
		
		public function removeTracelineGroup ( index : int )  : Boolean  
		{		
			return ( tracelineGroups.removeItemAt( index ) != null);	
		}
		
		public function moveTracelineGroup ( fromIndex : int, toIndex : int )  :void 
		{
			var temp : TraceLineGroup = tracelineGroups.removeItemAt( fromIndex ) as TraceLineGroup;
			tracelineGroups.addItemAt( temp, toIndex );
		}
		
		public function addTraceline(  traceline : TraceLine , parent : LayoutNode, xmlLayout : XML = null ) :  LayoutNode
		{
			var newNode : LayoutNode = new LayoutNode();				
			newNode.layout = null;	
			newNode.value = traceline
			
			parent.addChild( newNode );
			
			return newNode;
		}
		
		public function removeTraceline( ): Boolean 
		{ 
			return true; 
		}
		
		public function moveTraceline( destination : Object ):void {}
	
		public function createTracelineGroupTree ( trac : Trace ) : LayoutNode 
		{	
			var treeLayout : XML = new XML( TRACELINEGROUP );
			
			for each (var child : XML in _Root.layout.children() )
			{
				if ( child.hasOwnProperty('@source') )
				{
					if ( child.@source == trac.uri )
						{
							treeLayout = child;
							break;
						}
				}
				else
					treeLayout = child;
			}
			
			return  createTree(treeLayout, trac );			
		}
		
		static public function getTrace (node : LayoutNode ) : Trace
		{
			while (node && !(node.value is TraceLineGroup))
				node = node.parent;
			
			if (node)
				return ((node.value) as TraceLineGroup)._trace;
				
			return null;
		}
		
		static public function createTree ( xmlLayout : XML , trac : Trace) : LayoutNode 
		{
			var newNode : LayoutNode = null ;
			
			switch( xmlLayout.localName() )
			{				
				case TRACELINEGROUP :
				{
					newNode = new LayoutNode();
					newNode.layout = xmlLayout;			
					newNode.value =  new TraceLineGroup ( trac, xmlLayout.hasOwnProperty('@title')? xmlLayout.@title : trac.uri );									
					
					break;
				}
				
				case MODIFIER :
				{
					newNode = new LayoutNode();
					newNode.layout = xmlLayout;
					
					newNode.value =  new LayoutModifier ( );
					if ( xmlLayout.hasOwnProperty('@splitter') )									
						(newNode.value  as LayoutModifier)._splitter =  xmlLayout.@splitter ;	
							
					
					return newNode;
				}				
				
				case TRACELINE :	
				{
					var tlTitle : String;
					var tlSelector : ISelector;
					var tlSource : String;
					
					if ( xmlLayout.hasOwnProperty('@selector') )
					{
						if  ( xmlLayout.@selector == "SelectorRegexp")
						{
							tlTitle = "regexp : " + xmlLayout.@regexp;
							tlSelector = new SelectorRegexp(xmlLayout.@regexp, xmlLayout.@field);
						}
						else
						{
							var selectorClass:Class = getDefinitionByName( xmlLayout.@selector ) as Class;
							tlTitle = xmlLayout.@selector;							
							tlSelector = new selectorClass();
						}
					}
					
					newNode = new LayoutNode();				
					newNode.layout = xmlLayout;
					newNode.value = new TraceLine( tlTitle, tlSelector, tlSource );				

					break;
				}			
			}			
			
			for each ( var child : XML in xmlLayout.children() )
			{
					var newTree : LayoutNode = createTree( child, trac );
					newNode.addChild( newTree );	
					
					var collec : ArrayCollection;
					
						if (child.hasOwnProperty('@source') && child.@source == "parent" )
						{
							(newNode.value as TraceLine).source = xmlLayout.@source;						
							if (newNode.value is TraceLine)
								collec = (newNode.value as TraceLine)._obsels;
							else if (newNode.value is TraceLineGroup)
								collec = (newNode.value as TraceLineGroup)._trace.obsels;							
						}
						else						
							collec  = trac.obsels;		
							
					if ( newTree.value is TraceLine )
					{	
						collec.addEventListener( CollectionEvent.COLLECTION_CHANGE , (newTree.value as TraceLine).onSourceChange );
						(newTree.value as TraceLine).resetObselCollection( collec );
					} 
					else if ( newTree.value is LayoutModifier )
					{
						collec.addEventListener( CollectionEvent.COLLECTION_CHANGE , (newTree.value as LayoutModifier).onSourceChange );
						(newTree.value as LayoutModifier).resetObselCollection( collec );
					}				
			}
						
			return newNode;
		}		
	}
}