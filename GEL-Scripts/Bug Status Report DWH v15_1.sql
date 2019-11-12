<!-- This GEL Script solves this bug: https://ca-broadcom.wolkenservicedesk.com/external/article?articleId=7929 -->
<!-- When saving the Status Report object, the DWH checkbox, which is enabled by default and read-only, gets disabled and can no longer be re-enabled through the UI -->
<!-- More details at https://techdocs.broadcom.com/content/broadcom/techdocs/us/en/ca-enterprise-software/business-management/clarity-project-and-portfolio-management-ppm-on-demand/15-3/release-information/ca-ppm-15-3-resolved-defects.html#concept.dita_064379de60c95a0ca238a48d76f605a259adb122_DE32643S2Statusreportdisabledforincludeindwh -->

<gel:script 
   xmlns:core="jelly:core" 
   xmlns:gel="jelly:com.niku.union.gel.GELTagLibrary" 
   xmlns:sql="jelly:sql" 
   xmlns:email="jelly:email" 
   xmlns:file="jelly:com.niku.union.gel.FileTagLibrary" 
   xmlns:ftp="jelly:com.niku.union.gel.FTPTagLibrary" 
   xmlns:soap="jelly:com.niku.union.gel.SOAPTagLibrary" 
   xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
   xmlns:xog="http://www.niku.com/xog" 
   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
	<!-- Setting the database -->
	<core:catch var="connFail">
		<gel:setDataSource dbId="Niku" var="database"/>
	</core:catch>
	
	<!-- Checking if database is available -->
	<core:if test="${ connFail != null }">
		<gel:log level="error" message="Database not available!"/>
	</core:if>
	
	<!-- Enable Status Report for DWH -->
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[
			UPDATE odf_objects
			SET is_dw_enabled = ?
			WHERE code = ?
		]]>
		<sql:param value="1"/>
		<sql:param value="cop_prj_statusrpt"/>
	</sql:update>
	
	<!-- Enable Status Report attributes for DWH -->
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[
			UPDATE odf_custom_attributes
			SET is_dw_enabled = ?
			WHERE column_name in ('CODE', 'cop_cost_effort_ext', 'cop_cost_effort_rev', 'cop_cost_eft_staff', 'cop_cost_eft_status', 'cop_effort_exp', 'cop_key_accomplish', 'cop_overall_status', 'cop_report_date', 'cop_report_status', 'cop_report_update', 'cop_sched_milestone', 'cop_schedule_exp', 'cop_schedule_status', 'cop_scope_change', 'cop_scope_deliver', 'cop_scope_exp', 'cop_scope_obj', 'cop_scope_status', 'cop_upcoming_act', 'NAME')
			AND object_name = ?
		]]>
		<sql:param value="1"/>
		<sql:param value="cop_prj_statusrpt"/>
	</sql:update>
	
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[	
			UPDATE dwh_meta_tables SET is_deleted = ? WHERE is_system = ? AND src_table_name = ?
		]]>
		<sql:param value="0"/>
		<sql:param value="1"/>
		<sql:param value="dwh_cop_prj_statusrpt_v"/>
	</sql:update>
	
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[	
			UPDATE dwh_meta_columns SET is_deleted = ? WHERE src_table_name = ?
		]]>
		<sql:param value="0"/>
		<sql:param value="dwh_cop_prj_statusrpt_v"/>
	</sql:update>
	
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[	
			UPDATE DWH_META_COLUMNS SET IS_DELETED = ? WHERE IS_SYSTEM = ?
		]]>
		<sql:param value="0"/>
		<sql:param value="1"/>
	</sql:update>
	
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[	
			UPDATE DWH_META_TABLES SET IS_DELETED = ? WHERE IS_SYSTEM = ?
		]]>
		<sql:param value="0"/>
		<sql:param value="1"/>
	</sql:update>
	
	<sql:update dataSource="${database}" escapeText="0">
		<![CDATA[	
			COMMIT
		]]>
	</sql:update>
	
</gel:script>
