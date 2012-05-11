package com.rcs.liferaysense.common;

public interface Constants {
    public static final int UNDEFINED = -1;
    public static final String ORDER_BY_ASC = "asc";
    public static final String ORDER_BY_DESC = "desc"; 
    public static final int PAGINATION_DEFAULT_LIMIT = 5;    
    public static final String DATE_BACK_FORMAT = "yyyy-MM-dd";    
    public static final String DATE_FRONT_FORMAT = "Y-m-d";
    
    public static final String JQFORM_ACTION_ADD = "add";
    public static final String JQFORM_ACTION_EDIT = "edit";
    public static final String JQFORM_ACTION_DEL = "del";
    
    public static final String ADMIN_SECTION_ACCOUNT = "account";
    public static final String ADMIN_SECTION_ANALYTICS = "analytics";
    public static final String ADMIN_SECTION_GLOBAL_SETTINGS = "global-settings";
    
    public static final String ADMIN_SUBSECTION_TOP_MESSAGES = "top_messages";
    
    public static final String ADMIN_CONFIGURATION_ALLOW_AUTO_REGISTER = "auto_register";
    public static final String ADMIN_CONFIGURATION_ALLOW_CHANGE_SENSE_ACCOUNT = "allow_change_account";
    public static final String ADMIN_CONFIGURATION_DEFAULT_SENSE_USERNAME = "default_sense_username";
    public static final String ADMIN_CONFIGURATION_DEFAULT_SENSE_PASSWORD = "default_sense_pass";
    public static final String ADMIN_CONFIGURATION_DEFAULT_SENSE_LIFERAYSENSORDATA_ID = "default_sense_liferaysensordata_id";
    
    public static final String CHECKBOX_SELECTED_VALUE = "on";
    
    public static final String LIFERAY_SENSOR_NAME = "Liferay User Data";
    public static final String LIFERAY_SENSOR_DISPLAY_NAME = "Liferay User Data";
    public static final String LIFERAY_SENSOR_DATA_TYPE = "json";
    public static final String LIFERAY_SENSOR_DEVICE_TYPE = "LIFERAYUD";
    public static final String LIFERAY_SENSOR_TYPE = "2";
    public static final String LIFERAY_SENSOR_DATA_STRUCTURE="{\"ip\":\"string\", \"pageId\":\"long\", \"previous_pageId\":\"long\", \"page\":\"string\", \"previous_page\":\"string\", \"userAgent\":\"string\", \"liferayUserId\":\"long\"}";
    
    
    public static final int NETWORKMAP_ZOOM_ADJUST_FACTOR = 250;
    public static final int TIME_TO_KEEP_ALIVE_PAGE_NAVIGATION = 5; //Minutes
    
}