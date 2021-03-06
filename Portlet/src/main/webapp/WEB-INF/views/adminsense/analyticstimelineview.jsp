<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" 
    import="com.rcs.liferaysense.common.Constants"
    import="com.rcs.liferaysense.entities.enums.TimelineRange"
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@taglib prefix="aui" uri="http://liferay.com/tld/aui" %>
<%@taglib prefix="liferay-ui" uri="http://liferay.com/tld/ui" %>
<%@taglib prefix="theme" uri="http://liferay.com/tld/theme" %>
<%@taglib prefix="liferay-util" uri="http://liferay.com/tld/util" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<fmt:setBundle basename="Language"/>
<portlet:defineObjects />
<portlet:resourceURL var="getAnalyticsRangeURL" id="getAnalyticsRange" />
<portlet:resourceURL var="getAnalyticsBigRangeJSONURL" id="getAnalyticsBigRangeJSON" />

<script type="text/javascript">
    var startTime = "${fromDate}";
    var endTime = "${toDate}";
    var loading = false;
    var data;
    var timelne;
    var runningProcess = null;
    
    function drawVisualizationimeline<portlet:namespace/>(sensordata) {
        var selectedRange = jQuery('input:radio[name=<portlet:namespace/>range]:checked').val();
        data = new google.visualization.DataTable();
        data.addColumn('datetime', 'start');
        data.addColumn('datetime', 'end');
        data.addColumn('string', 'content');
        data.addColumn('string', 'group');        
        
        if (sensordata == null) {
            data.addRows([
                <c:forEach items="${liferaySensorsData}" var="row" varStatus="rowCounter">  
                    <c:if test="${rowCounter.count > 1}" >,</c:if>
                    [new Date(${row.timestamp}), ,'${row.pageCounter}', '${row.page}']
                </c:forEach>
            ]);
        } else {
            jQuery.each(sensordata, function(index, row) {
                data.addRows([[new Date(row.timestamp),undefined ,"" + row.pageCounter,row.page]]);
            });
        }

        var options = {
             "style": "box"
            ,"editable":false
            ,"selecteable":false
            ,"animate":false
            ,"animateZoom":false
        };

        timeline = new links.Timeline(document.getElementById('<portlet:namespace/>mytimeline'));
        
        if (selectedRange != <%=TimelineRange.REAL_TIME.getId()%>) {
            google.visualization.events.addListener(timeline, 'select', onselect);
            google.visualization.events.addListener(timeline, 'rangechange', onrangechange);  
            google.visualization.events.addListener(timeline, 'rangechanged', onrangechanged);      
        }

        timeline.draw(data, options);
        
        //timeline.setScale(links.Timeline.StepDate.SCALE.MINUTE, 10) //Real Time
        //timeline.setScale(links.Timeline.StepDate.SCALE.HOUR, 1) //Last Hour
        //timeline.setScale(links.Timeline.StepDate.SCALE.DAY, 1); //Last Day
        //timeline.setScale(links.Timeline.StepDate.SCALE.DAY, 7); //Last Week
        //timeline.setScale(links.Timeline.StepDate.SCALE.MONTH, 1); //Last Month
        
        if (selectedRange == <%=TimelineRange.REAL_TIME.getId()%>) {
            timeline.setVisibleChartRange(new Date(startTime), new Date(endTime));
            timeline.setVisibleChartRangeNow();
        }
    }  
    
    function reloadTimeline<portlet:namespace/>() {
        var currentHeight = jQuery("#<portlet:namespace/>mytimeline .timeline-frame").height();
        jQuery("#<portlet:namespace/>mytimeline").css("min-height", currentHeight + "px");
        jQuery.get("${getAnalyticsBigRangeJSONURL}"
            ,{
                "range" : jQuery('input:radio[name=<portlet:namespace/>range]:checked').val()
            }
            ,function(returned_data) {
                rows = jQuery.parseJSON(returned_data);
                drawVisualizationimeline<portlet:namespace/>(rows.liferaySensorsData);
                startTime = rows.startTime;
                endTime = rows.endTime;
            }
        );
    }
    
    function onrangechange() {
        var range = timeline.getVisibleChartRange();
        jQuery('#<portlet:namespace/>startDate').html('<fmt:message key="com.rcs.sense.admin.analytics.start.time"/>: <b> ' + dateFormat(range.start) + ' </b> ');
        jQuery('#<portlet:namespace/>endDate').html(' &nbsp; - &nbsp; <fmt:message key="com.rcs.sense.admin.analytics.end.time"/>: <b> ' + dateFormat(range.end) + ' </b> ');
        startTime = range.start;
        endTime = range.end;
    }
    
    function onrangechangeddelayed() {   
        var newStartDate = new Date(startTime);
        var newEndDate   = new Date(endTime);
        jQuery("#<portlet:namespace/>mynetworkcontainer").load("${getAnalyticsRangeURL}"
            ,{
                 "startTime" : newStartDate.getTime()
                ,"endTime" : newEndDate.getTime()
            }
            ,function() {            
                jQuery("#<portlet:namespace/>mynetworkcontainer").unmask();
                loading = false;                
            }
        );
    }
    
    function onrangechanged() {    
        if (!loading) {
            jQuery("#<portlet:namespace/>mynetworkcontainer").mask('<fmt:message key="com.rcs.sense.general.mask.loading.text"/>');
            loading = true;
            setTimeout(onrangechangeddelayed, 1000);
        }
    }

    <%--//Format given date as "yyyy-mm-dd hh:ii:ss"
    //@param datetime   A Date object.--%>
    function dateFormat(date) {
        datetime =   date.getFullYear() + "-" + 
        ((date.getMonth()   <  9) ? "0" : "") + (date.getMonth() + 1) + "-" +
        ((date.getDate()    < 10) ? "0" : "") +  date.getDate() + " " +
        ((date.getHours()   < 10) ? "0" : "") +  date.getHours() + ":" + 
        ((date.getMinutes() < 10) ? "0" : "") +  date.getMinutes() + ":" + 
        ((date.getSeconds() < 10) ? "0" : "") +  date.getSeconds()
        return datetime;
    }

    jQuery(function () {
        jQuery("#<portlet:namespace/>mynetworkcontainer").mask('<fmt:message key="com.rcs.sense.general.mask.loading.text"/>');
        drawVisualizationimeline<portlet:namespace/>();
        onrangechangeddelayed();        
    });
</script>

<div>
    <strong><fmt:message key="com.rcs.sense.admin.analytics.general.report"/>: </strong>    
    <span id="<portlet:namespace/>endDate" class="sense-graphic-daterange"></span>
    <span id="<portlet:namespace/>startDate" class="sense-graphic-daterange"></span>
</div>
<div id="<portlet:namespace/>mytimeline" class="sense-graphic-container sense-graphic-container-white"></div>
