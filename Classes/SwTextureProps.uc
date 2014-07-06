/* =============================================================================
:: Copyright © 2006 Roman Dzieciol
============================================================================= */
class SwTextureProps extends BrushBuilder config(SwTextureProps);

enum EAction
{
	PropRead,
	PropWrite
};

enum EApplyTo
{
	Object,
	OuterGroup
};


var() transient EAction Action;
var() config EApplyTo ApplyTo;

var() config string PropName;
var() config string PropValue;


event bool Build()
{
	local UnrealEdEngine E;

	foreach AllObjects(class'UnrealEdEngine', E)
	{
		Log( E, class.name );
		break;
	}
	
	if( E == None )
		return BadParameters( "UnrealEdEngine not found" );
	
	if( E.CurrentTexture == None )
		return BadParameters( "Select texture first" );
		
	switch( Action )
	{
		case PropRead:
			if( PropName == "" )
				return BadParameters( "PropName not set" );
		break;
		
		case PropWrite:
			if( PropName == "" )
				return BadParameters( "PropName not set" );
				
			if( PropValue == "" )
				return BadParameters( "PropValue not set" );
				
		break;
	}
	
	Apply( E.CurrentTexture );
		
		
	SaveConfig();
	return false;
}

final function bool Apply( Texture Selected )
{
	local Texture T;
	local Object O;
	
	switch( ApplyTo )
	{
		case Object:
			Process( Selected );
		break;
		
		case OuterGroup:
				
			O = Selected.Outer;
			if( O == None )
				return BadParameters( "Selected texture has no group" );
			
			foreach AllObjects(class'Texture', T)
			{	
				if( T.Outer == O )
				{
					Process(T);
				}
			}
		break;
	}
}

final function Process( Texture T )
{
	switch( Action )
	{
		case PropWrite:
			T.SetPropertyText( PropName, PropValue );
		break;
		
		case PropRead:
			PropValue = "";
			PropValue = T.GetPropertyText( PropName );
		break;
	}

	Log( T @PropName $"=" $PropValue, class.name );
}


DefaultProperties
{
	ToolTip="SwTextureProps"
	BitmapFilename="SwTextureProps"
}
