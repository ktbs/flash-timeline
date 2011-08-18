package com.ithaca.timeline
{
	import com.ithaca.traces.Trace;
	import flash.utils.getDefinitionByName;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	public class Layout
	{
		public static const TRACELINEGROUP: String = "tlg";
		public static const TRACELINE: String = "tl";
		public static const MODIFIER: String = "modifier";
		public static const ROOT: String = "root";
		
		public static const backgroundTraceLine: String = "background";
		public static const contextPreviewTraceLine: String = "contextPreview";

		private var _timeline : Timeline;
		
		public function Layout( tl : Timeline )
		{			
			_timeline = tl;			
		}
		
//		public function get tracelineGroups() : ArrayCollection { return _Root.getEchildren; }
		
		public function addTracelineGroupTree (  node : LayoutNode,  index : int = -1) : void
		{
			if ( node )		
				_timeline.addChildAndTitle(  node , index );			
		}
		
		public function removeTraceline( ): Boolean 
		{ 
			return true; 
		}
		
		public function moveTraceline(  ):void {}
	
		public function createTracelineGroupTree ( trac : Trace ) : TraceLineGroup 
		{	
			var treeLayout : XML = new XML( TRACELINEGROUP );
			
			for each (var child : XML in _timeline.layoutXML.children() )
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
			
			return  createTree(treeLayout, trac ) as TraceLineGroup;			
		}
		
		static public function getTrace (node : LayoutNode ) : Trace
		{
			while (node && !(node is TraceLineGroup))
				node = node.parentNode;
			
			if (node)
				return (node as TraceLineGroup)._trace;
				
			return null;
		}
		
		public function createTraceLineGroupNode(  xmlLayout : XML , trac : Trace ) : TraceLineGroup
		{
			var newNode : TraceLineGroup = new TraceLineGroup ( _timeline, trac, xmlLayout.hasOwnProperty('@title')? xmlLayout.@title : trac.uri );	
			newNode.layoutXML = xmlLayout;			

			return newNode;
		}
		
		public function addTraceline(  traceline : TraceLine , parentNode : LayoutNode , xmlLayout : XML = null ) :  LayoutNode
		{
			parentNode.addChildAndTitle( traceline );
			return traceline;
		}
		
		public function createTraceLineNode(  xmlLayout : XML  ) : TraceLine
		{
			var newNode : TraceLine;
			var tlTitle : String;
			var tlClass : String;
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
			if ( xmlLayout.hasOwnProperty('@title') )
				tlTitle = xmlLayout.@title; 
			if ( xmlLayout.hasOwnProperty('@skinClass') )
				tlClass = xmlLayout.@skinClass; 
			
			newNode = new TraceLine( _timeline, tlTitle, tlSelector, tlSource, tlClass  );
			newNode.layoutXML = xmlLayout;			
			
			return newNode;
		}
		
		public function createModifierNode(  xmlLayout : XML  ) : LayoutModifier
		{
			var newNode : LayoutModifier = new LayoutModifier ( _timeline );
			newNode.layoutXML = xmlLayout;
		
			if ( xmlLayout.hasOwnProperty('@splitter') )									
					newNode._splitter =  xmlLayout.@splitter ;	

			return newNode;
		}
		
		public function createTree ( xmlLayout : XML , trac : Trace) : LayoutNode 
		{		
			var newNode : LayoutNode = null;
			
			switch( xmlLayout.localName() )
			{				
				case TRACELINEGROUP :
					newNode = createTraceLineGroupNode( xmlLayout, trac );							
					break;
				
				case MODIFIER :
					return createModifierNode( xmlLayout );						
				
				case TRACELINE :	
					newNode = createTraceLineNode( xmlLayout );
					break;	
					
				default:
					return null;
			}			
			
			for each ( var child : XML in xmlLayout.children() )
			{
				var childTree : LayoutNode = createTree( child, trac );
				
				if ( child.hasOwnProperty('@skinClass') && child.@skinClass == backgroundTraceLine )
				{			
					if (newNode is TraceLineGroup)
						(newNode as TraceLineGroup).backgroundTraceLine = childTree as TraceLine;
				}
				else if ( child.hasOwnProperty('@skinClass') && child.@skinClass == contextPreviewTraceLine )
				{
					if (newNode is TraceLineGroup)
						(newNode as TraceLineGroup).contextPreviewTraceLine = childTree as TraceLine;
				}				
				else
				{
					newNode.addChildAndTitle( childTree );	
				}
				
				var collec : ArrayCollection;				
				if (child.hasOwnProperty('@source') && child.@source == "parent" )
				{
					(newNode as TraceLine).sourceStr = xmlLayout.@source;						
					if (newNode is TraceLine)
						collec = (newNode as TraceLine)._obsels;
					else if (newNode is TraceLineGroup)
						collec = (newNode as TraceLineGroup)._trace.obsels;							
				}
				else						
					collec  = trac.obsels;		
						
				collec.addEventListener( CollectionEvent.COLLECTION_CHANGE , childTree.onSourceChange );
				childTree.resetObselCollection( collec );			
			}
						
			return newNode;
		}		
	}
}