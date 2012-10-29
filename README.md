# Redmine Custom Reports (with charts) plugin

Redmine plugin to create project reports using [d3.js](http://d3js.org/) charts (with using [NVD3](http://nvd3.com/)). The data for the report - the number of filtered issues grouped by a column.

You can use multiple data series. Issues filtered by ordinary redmine filters.

Tickets are grouped together on the same field, on how tickets can be grouped in a query. Additionally, you can group tickets by text custom fields. In addition to regular columns, you can use custom fields with type "text" to group.

## Permissions

There are public and private custom reports. Permission "View custom reports" allows user to view public and private reports. Permission "Manage custom reports" allows user to manage their (private) reports. And last permission "Manage public custom reports" allows user to manage public reports.

## Installing a plugin

Follow the plugin installation procedure at http://www.redmine.org/projects/redmine/wiki/Plugins#Installing-a-plugin

Restart the application and go to one of your project settings.
Click on the Modules tab. You should see the "Custom reports" module at the end of the modules list.
Enable plugin at project level. Now you will see "Custom report" tab at the project menu.

## Screenshot

![Sample](https://github.com/nodecarter/redmine_custom_reports/raw/master/screenshot.png)
