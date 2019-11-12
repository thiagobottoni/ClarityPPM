-- Documenting your Configuration (via SQL)
-- Source: https://community.broadcom.com/communities/community-home/digestviewer/viewthread?MID=712799

-- Replace 'xxxxxxxx' with an object name, for example 'project'

select
 ( select name from cmn_captions_nls where language_code = 'en'
  and table_name = 'ODF_CUSTOM_ATTRIBUTES'
  and pk_id = A.id ) AS "Attribute"
,( select description from cmn_captions_nls where language_code = 'en'
  and table_name = 'ODF_CUSTOM_ATTRIBUTES'
  and pk_id = A.id ) AS "Description"
, initcap(data_type) as "Data Type"
, default_value AS "Default" 
, internal_name AS "Database Column / Attribute ID"
, decode(lookup_type,null,'','Lookup name '''||(select C.name
from
  cmn_captions_nls C
, cmn_lookup_types L
where L.lookup_type = A.lookup_type
and C.pk_id = L.id
and language_code = 'en'
and table_name = 'CMN_LOOKUP_TYPES')||' / '||(lookup_type)||''' ') ||
decode(A.is_editable,0,'Read-only "Checked" ',null)||
decode(A.extended_type,'lookup',null,decode(A.data_type,'string','Maximum Size: '||data_size||' ',null)) ||
decode(A.extended_type,'lookup',null,decode(A.data_type,'number','Decimal places: '||scale,null)) AS "Miscellaneous"
from odf_custom_attributes A
where object_name = 'xxxxxxxx'
and internal_name != 'partition_code'
order by A.created_date asc;


-- For VIEW configurations, use the following

-- Replace 'yyyyyyyyy' with the view "ID" that you see on the View/Page screen (or Subpage screen for edit views) - for example 'projectGeneral'

select ovs.label As "Section"
,VAT.name  AS "Property Label"
,decode(ova.col,1,'Left',2,'Right',ova.col) As "Column"
,attribute_code||DECODE(CAT.name,null,null,' ('||CAT.name||')') as "Attribute"
,decode(widget_type,'text','String','textarea','String','browse','Lookup','select'
,'Lookup','datepicker','Date','checkbox','Boolean',widget_type) As "Data Type"
,decode(widget_type,'text','Text Entry','textarea','Text Entry','browse','Browse'
,'select','Pull-Down','datepicker','Date','checkbox','Check Box',widget_type) As "Display Type"
,decode(ova.is_required,'1','Y') As "Required"
,decode(ova.is_editable,'1','',0,'Y') As "Read-Only"
,CASE WHEN widget_type = 'checkbox'
 THEN decode(ova.default_value,0,'Unchecked','Checked')
 ELSE
 decode(ova.default_value,'date_today','Today','date_tomorrow','Tomorrow','userId','Current User','',''
     ,'Value '''||ova.default_value||''' from lookup')
 END  AS "Default"
FROM
odf_views ov
JOIN odf_objects oo on ( oo.code = ov.object_code )
JOIN odf_view_attributes ova on ( ova.view_id = ov.id )
LEFT JOIN cmn_captions_nls VAT ON ( ova.label_pk_id=VAT.pk_id and VAT.language_code = 'en'
     and VAT.table_name='ODF_VIEW_ATTRIBUTES' )
LEFT JOIN odf_custom_attributes oca on ( oca.object_name = oo.code
     and oca.internal_name = ova.attribute_code )
LEFT JOIN cmn_captions_nls CAT ON ( CAT.table_name = 'ODF_CUSTOM_ATTRIBUTES' 
     and CAT.pk_id = oca.id and CAT.language_code = 'en' )   
LEFT JOIN odf_view_sections ovs on ( ovs.id=ova.section_id )
WHERE ov.code = 'yyyyyyyyy'
and hidden != 1
and section_id != -1
ORDER BY ova.section_id , ova.col , ova.display_order asc
