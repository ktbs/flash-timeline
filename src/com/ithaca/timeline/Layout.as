package com.ithaca.timeline
{
	import com.ithaca.traces.Trace;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import flash.ui.MouseCursor
	
	public class Layout
	{
		public static const TRACELINEGROUP	: String = "tlg";
		public static const TRACELINE		: String = "tl";
		public static const MODIFIER		: String = "modifier";
		public static const ROOT			: String = "root";
		public static const LAYOUT			: String = "layout";
		public static const OBSELS_SELECTORS: String = "obselsSelectors";
		public static const OBSELS_SELECTOR: String = "obselsSelector";
		
		public static const backgroundTraceLine: String = "background";
		public static const contextPreviewTraceLine: String = "contextPreview";

		private var _timeline : Timeline;
		
		public function Layout( tl : Timeline )
		{			
			_timeline = tl;			
		}
		
		public function addTracelineGroup (  tlg : TraceLineGroup,  index : int = -1) : void
		{
			if ( tlg )		
				_timeline.addChildAndTitle(  tlg , index );	
				
			getCurrentXmlLayout();
		}
		
		public function removeTraceline( ): Boolean 
		{ 
			return true; 
		}
		
		public function moveTraceline(  ):void {}
	
		public function createTracelineGroupTree ( trac : Trace, style : String = null ) : TraceLineGroup 
		{	
			var treeLayout : XML = new XML( TRACELINEGROUP );
			
			for each (var child : XML in _timeline.layoutXML[LAYOUT].children() )
			{				
				if (   ( child.hasOwnProperty('@style') && child.@style == style )
					|| ( child.hasOwnProperty('@source') && child.@source == trac.uri ))
				{					
					treeLayout = child;
					break;						
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
				return (node as TraceLineGroup).trace;
				
			return null;
		}
				
		public function createTraceLineGroupNode(  xmlLayout : XML , trac : Trace ) : TraceLineGroup
		{
			var newNode : TraceLineGroup = new TraceLineGroup ( _timeline, trac, xmlLayout.hasOwnProperty('@title')? xmlLayout.@title : trac.uri, xmlLayout.hasOwnProperty('@style')?xmlLayout.@style:null);	
			newNode.layoutXML = xmlLayout;			

			return newNode;
		}
		
		public function addTraceline(  traceline : TraceLine , parentNode : LayoutNode , xmlLayout : XML = null ) :  LayoutNode
		{
			parentNode.addChildAndTitle( traceline );
			return traceline;
		}
		
		private function createSelector( xmlSelector : XML ) : ISelector
		{
			var tlSelector : ISelector;
			
			if ( xmlSelector.hasOwnProperty('@selector') )
			{
				var selectorClass:Class;
				
				try {
					selectorClass = getDefinitionByName( xmlSelector.@selector ) as Class;
				}
				catch(error:ReferenceError)	{				
					selectorClass = getDefinitionByName( "com.ithaca.timeline::" + xmlSelector.@selector ) as Class;	
				}
				
				tlSelector = new selectorClass( );	
				
				if ( xmlSelector.hasOwnProperty('@selectorParams') )
				{
					var str		: String = xmlSelector.@selectorParams ;
					var params 	: Array = str.split(',');

					tlSelector.setParameters( params );			
				}
			}
			
			return tlSelector;
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
				tlSelector 	= createSelector( xmlLayout );
				tlTitle		= xmlLayout.@selector;	
			}
			if ( xmlLayout.hasOwnProperty('@title') )
				tlTitle = xmlLayout.@title; 
			if ( xmlLayout.hasOwnProperty('@style') )
				tlClass = xmlLayout.@style; 
			if ( xmlLayout.hasOwnProperty('@source') )
				tlSource = xmlLayout.@source;
							
			newNode = new TraceLine( _timeline, tlTitle, tlSelector, tlSource, tlClass  );
			
			if ( xmlLayout.hasOwnProperty('@autohide') &&  xmlLayout.@autohide =='true')
				newNode.autohide = true;				

			newNode.layoutXML = xmlLayout;			
			
			return newNode;
		}
		
		public function createModifierNode(  xmlLayout : XML  ) : LayoutModifier
		{
			var newNode : LayoutModifier = new LayoutModifier ( _timeline );
			newNode.layoutXML = xmlLayout;
		
			if ( xmlLayout.hasOwnProperty('@splitter') )									
				newNode._splitter =  xmlLayout.@splitter ;	
			if ( xmlLayout.hasOwnProperty('@source') )
				newNode.source = xmlLayout.@source;
			if ( xmlLayout.hasOwnProperty('@style') )
			{
				var style : String = xmlLayout.@style; 
				newNode.styleName = style;
			}
			
			if ( xmlLayout.hasOwnProperty('@name') )
			{
				var modName : String = xmlLayout.@name; 
				newNode.name = modName;
			}

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
				
				if ( child.hasOwnProperty('@style') && child.@style == backgroundTraceLine )
				{			
					if (newNode is TraceLineGroup)
						(newNode as TraceLineGroup).backgroundTraceLine = childTree as TraceLine;
				}
				else
				{ 
					if ( child.hasOwnProperty('@preview') && child.@preview == 'true' && newNode is TraceLineGroup )
						(newNode as TraceLineGroup).contextPreviewTraceLine = childTree as TraceLine;
						
					newNode.addChildAndTitle( childTree );	
				}				
				
				var collec : ArrayCollection;				
				if (child.hasOwnProperty('@source') && child.@source == "parent" )
				{
					(newNode as TraceLine).sourceStr = xmlLayout.@source;						
					if (newNode is TraceLine)
						collec = (newNode as TraceLine)._obsels;
					else if (newNode is TraceLineGroup)
						collec = (newNode as TraceLineGroup).trace.obsels;							
				}
				else						
					collec  = trac.obsels;		
						
				collec.addEventListener( CollectionEvent.COLLECTION_CHANGE , childTree.onSourceChange );
				childTree.resetObselCollection( collec );			
			}
						
			return newNode;
		}		
	
		public function getCurrentXmlLayout ( ) : XML
		{
			var currentXmlLayout : XML = < {ROOT} />;
			
			currentXmlLayout.appendChild( layoutTreeToXml() );
			currentXmlLayout.appendChild( obselsSelectorsToXml() );
			
			trace( currentXmlLayout.toXMLString() );
			return currentXmlLayout;
		}				
		
		public function loadObselsSelectors( xmlSelectors : XMLList ) : void 
		{
			for each (var selector : XML in xmlSelectors.children() )
			{	
				if ( selector.hasOwnProperty('@selector') )
				{
					var obselSelector : ISelector 	= createSelector( selector );
					if ( selector.hasOwnProperty('@id') )					
					{
						var selectorId : String = selector.@id;
						_timeline.styleSheet.obselsSkinsSelectors.push( { id:selectorId, selector:obselSelector } );						
					}
				}			
			}
		}
		
		protected function obselsSelectorsToXml ( ) : XML
		{
			var xmlTree 	: XML = <{OBSELS_SELECTORS} />;
			
			if ( _timeline.styleSheet && _timeline.styleSheet.obselsSkinsSelectors)	
				for each (var selector : Object in _timeline.styleSheet.obselsSkinsSelectors )
				{	
					var xmlSelector 	: XML = <{OBSELS_SELECTOR} />;					
					
					if ( selector.id )
						xmlSelector.@['id'] = selector.id;
				
					if  (selector.selector)
					{
						xmlSelector.@['selector'] = getQualifiedClassName( selector.selector );
						xmlSelector.@['selectorParams'] = selector.selector.getParameters();
					}						
					xmlTree.appendChild( xmlSelector );		
				}

			return xmlTree;
		}
		
		protected function layoutTreeToXml ( ) : XML
		{
			var xmlTree 	: XML = <{LAYOUT} />;
			var sourceList 	: ArrayCollection = new ArrayCollection();
			
			for ( var tlgIndex : uint = 0; tlgIndex < _timeline.numElements; tlgIndex++ )
			{
				var tlg : TraceLineGroup = _timeline.getElementAt( tlgIndex ) as TraceLineGroup;
				if ( tlg && sourceList.getItemIndex( tlg.trace.uri ) < 0)
				{									
					sourceList.addItem( tlg.trace.uri ) 
					var xmlTlg : XML 	= < {TRACELINEGROUP} />;
					xmlTlg.@['source']	= tlg.trace.uri;
					if ( tlg.styleName )
						xmlTlg.@['style']	= tlg.styleName;
						
					for ( var tlIndex : uint = 0; tlIndex < tlg.numElements; tlIndex++ )
					{
						var layoutNode : LayoutNode = tlg.getElementAt( tlIndex ) as LayoutNode;
						
						if (layoutNode is TraceLine )												
							xmlTlg.appendChild( tracelineTreeToXml( layoutNode as TraceLine) );	
						else if (layoutNode is LayoutModifier )							
							xmlTlg.appendChild( modifierTreeToXml( layoutNode as LayoutModifier) );	
					}						
						
					xmlTree.appendChild( xmlTlg );							
				}				
			}
			
			xmlTree.appendChild( _timeline.layoutXML[LAYOUT].children() );		
			return xmlTree;
		}
		
		protected function tracelineTreeToXml ( tl : TraceLine ) : XML
		{			
			var xmlTl 	: XML = <{TRACELINE} />;
			if ( tl.sourceStr )
				xmlTl.@['source']	= tl.sourceStr;
			if ( tl.styleName )
				xmlTl.@['style'] = tl.styleName;
			if ( tl.title )
				xmlTl.@['title'] = tl.title;
			if ( tl.autohide )
				xmlTl.@['autohide'] = tl.autohide;
				
			if  (tl.selector)
			{
				xmlTl.@['selector'] = getQualifiedClassName( tl.selector );
				xmlTl.@['params'] = tl.selector.getParameters();
			}
			
			for ( var tlIndex : uint = 0; tlIndex < tl.numElements; tlIndex++ )
			{
				var layoutNode : LayoutNode = tl.getElementAt( tlIndex ) as LayoutNode;
				
				if (layoutNode is TraceLine )												
					xmlTl.appendChild( tracelineTreeToXml( layoutNode as TraceLine) );	
				else if (layoutNode is LayoutModifier )							
					xmlTl.appendChild( modifierTreeToXml( layoutNode as LayoutModifier) );	
			}			
			
			return xmlTl;			
		}		
		
		protected function modifierTreeToXml ( modifier : LayoutModifier ) : XML
		{			
			var xmlModifier 	: XML = <{MODIFIER} />;
			
			if ( modifier.source )
				xmlModifier.@['source']	= modifier.source;
			if ( modifier.styleName )
				xmlModifier.@['style'] = modifier.styleName;
			if ( modifier.name )
				xmlModifier.@['name'] = modifier.name;
			if ( modifier._splitter )
				xmlModifier.@['splitter'] = modifier._splitter;

			for ( var tlIndex : uint = 0; tlIndex < modifier.numElements; tlIndex++ )
			{
				var layoutNode : LayoutNode = modifier.getElementAt( tlIndex ) as LayoutNode;
				
				if (layoutNode is TraceLine )												
					xmlModifier.appendChild( tracelineTreeToXml( layoutNode as TraceLine) );	
				else if (layoutNode is LayoutModifier )							
					xmlModifier.appendChild( modifierTreeToXml( layoutNode as LayoutModifier) );	
			}			
			
			return xmlModifier;			
		}		
	}
}