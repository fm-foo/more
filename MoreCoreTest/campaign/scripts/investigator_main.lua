
-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	getDatabaseNode().onObserverUpdate = onObserverUpdated;
	onObserverUpdated();
	update();
end

function onObserverUpdated()
	local node = getDatabaseNode();
	
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
	update();
end

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then
		return false;
	end
		
	if not bID then
		return self[sControl].update(bReadOnly, true);
	end
	
	return self[sControl].update(bReadOnly);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	

	if updateControl("inplace", bReadOnly, true) then inplace = false; end
	if updateControl("description", bReadOnly, true) then description = false; end
	if updateControl("pcdiscussion", bReadOnly, true) then pcdiscussion = false; end
	if updateControl("links", bReadOnly, true) then links = false; end
	if updateControl("status", bReadOnly, true) then status = false; end

end

