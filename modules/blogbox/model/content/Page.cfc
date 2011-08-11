/**
* I am a blog page entity
*/
component persistent="true" entityname="bbPage" table="bb_page" batchsize="10" extends="BaseContent"{
	
	// Properties
	property name="pageID" fieldtype="id" generator="native" setter="false";
	property name="layout"	notnull="false"  length="200" default="";
	
	// O2M -> Comments
	property name="comments" singularName="comment" fieldtype="one-to-many" type="array" lazy="extra" batchsize="10" orderby="createdDate"
			  cfc="blogbox.model.comments.Comment" fkcolumn="FK_pageID" inverse="true" cascade="all-delete-orphan"; 
	
	// M20 -> Parent Page loaded as a proxy
	property name="parent" notnull="false" cfc="blogbox.model.content.Page" fieldtype="many-to-one" fkcolumn="FK_parentID" lazy="true";
	
	// Calculated Fields
	property name="numberOfComments" 			formula="select count(*) from bb_comment comment where comment.FK_pageID=pageID";
	property name="numberOfApprovedComments" 	formula="select count(*) from bb_comment comment where comment.FK_pageID=pageID and comment.isApproved = 1";

	/* ----------------------------------------- ORM EVENTS -----------------------------------------  */
	
	/* ----------------------------------------- PUBLIC -----------------------------------------  */
	
	
	/*
	* Validate page, returns an array of error or no messages
	*/
	array function validate(){
		var errors = [];
		
		// limits
		HTMLKeyWords 		= left(HTMLKeywords,160);
		HTMLDescription 	= left(HTMLDescription,160); 
		passwordProtection 	= left(passwordProtection,100);
		title				= left(title,200);
		slug				= left(slug,200);
		
		// Required
		if( !len(title) ){ arrayAppend(errors, "Title is required"); }
		if( !len(content) ){ arrayAppend(errors, "Content is required"); }
		//if( !len(layout) ){ arrayAppend(errors, "Layout is required"); }
		
		return errors;
	}
	
	/**
	* is loaded?
	*/
	boolean function isLoaded(){
		return len( getPageID() );
	}
	
}