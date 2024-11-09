-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	TypeChanged();
	onLockChanged();
	onIDChanged();
end

function TypeChanged()
	local sType = DB.getValue(getDatabaseNode(), "worldtype", "");
	Debug.console("TypeChanged: ", sType, getDatabaseNode(), DB.getValue(getDatabaseNode(), "worldtype", ""));
	
	if sType == "Religion" then
		tabs.setTab(1, "world_religion", "tab_main");
	elseif sType == "Group" then
		tabs.setTab(1, "world_group", "tab_main");
	else
		tabs.setTab(1, "world_place", "tab_main");
	end
end

function onLockChanged()
	StateChanged();
end

function StateChanged()
	if header.subwindow then
		header.subwindow.update();
	end
	if world_place.subwindow then
		world_place.subwindow.update();
	end
	if world_group.subwindow then
		world_group.subwindow.update();
	end
	if world_religion.subwindow then
		world_religion.subwindow.update();
	end

	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	
--	worldtype.setReadOnly(bReadOnly);
	text.setReadOnly(bReadOnly);
end

function onIDChanged()
	onNameUpdated();
	if header.subwindow then
		header.subwindow.updateIDState();
	end
	if User.isHost() then
		if world_place.subwindow then
			world_place.subwindow.update();
		end
		if world_group.subwindow then
			world_group.subwindow.update();
		end
		if world_religion.subwindow then
			world_religion.subwindow.update();
		end
	else
		local bID = LibraryData.getIDState("world", getDatabaseNode(), true);
		tabs.setVisibility(bID);
		worldtype.setVisible(bID);
	end
end

function onNameUpdated()
	local nodeRecord = getDatabaseNode();
	local bID = LibraryData.getIDState("world", nodeRecord, true);
	
	local sTooltip = "";
	if bID then
		sTooltip = DB.getValue(nodeRecord, "name", "");
		if sTooltip == "" then
			sTooltip = Interface.getString("library_recordtype_empty_world")
		end
	else
		sTooltip = DB.getValue(nodeRecord, "nonid_name", "");
		if sTooltip == "" then
			sTooltip = Interface.getString("library_recordtype_empty_nonid_world")
		end
	end
	setTooltipText(sTooltip);
end
