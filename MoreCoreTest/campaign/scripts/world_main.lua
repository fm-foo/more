--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	update();
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
	local sType = worldtype.getValue();
	local bSection1 = false;
	local bSection2 = false;
	local bSection3 = false;
	local bSection4 = false;

	if sType == "" then
		updateControl("inplace", bReadOnly, false);
		updateControl("hq", bReadOnly, false);
		updateControl("description", bReadOnly, false);
		button_chat_place.setVisible(false);
		updateControl("gmdescription", bReadOnly, false);
		updateControl("pcdescription", bReadOnly, false);
		updateControl("placetype", bReadOnly, false);
		updateControl("demographics", bReadOnly, false);
		updateControl("languages", bReadOnly, false);
		updateControl("economy", bReadOnly, false);
		updateControl("government", bReadOnly, false);
		updateControl("history", bReadOnly, false);
		updateControl("religion", bReadOnly, false);
		updateControl("grouptype", bReadOnly, false);
		updateControl("purpose", bReadOnly, false);
		updateControl("alignment", bReadOnly, false);
		updateControl("goals", bReadOnly, false);
		updateControl("obligations", bReadOnly, false);
		updateControl("deity", bReadOnly, false);
		updateControl("adherents", bReadOnly, false);
		updateControl("funding", bReadOnly, false);
		updateControl("leader", bReadOnly, false);
		updateControl("npcs", bReadOnly, false);
		updateControl("images", bReadOnly, false);
		updateControl("places", bReadOnly, false);
		updateControl("status", bReadOnly, false);
		updateControl("gender", bReadOnly, false);
		updateControl("race", bReadOnly, false);
		updateControl("occupation", bReadOnly, false);
		updateControl("faction", bReadOnly, false);
		updateControl("relationships", bReadOnly, false);
	elseif sType == "Place" then
		if updateControl("inplace", bReadOnly, true) then bSection1 = true; end
		updateControl("hq", bReadOnly, false)
		if updateControl("description", bReadOnly, true) then bSection1 = true; end
		if updateControl("gmdescription", bReadOnly, true) then bSection1 = true; end
		button_chat_place.setVisible(true);
		if updateControl("pcdescription", bReadOnly, true) then bSection2 = true; end
		if updateControl("placetype", bReadOnly, true) then bSection2 = true; end
		if updateControl("demographics", bReadOnly, true) then bSection2 = true; end
		if updateControl("languages", bReadOnly, true) then bSection2 = true; end
		if updateControl("economy", bReadOnly, true) then bSection2 = true; end
		if updateControl("government", bReadOnly, true) then bSection2 = true; end
		if updateControl("history", bReadOnly, true) then bSection2 = true; end
		if updateControl("religion", bReadOnly, true) then bSection2 = true; end
		updateControl("grouptype", bReadOnly, false);
		updateControl("purpose", bReadOnly, false);
		updateControl("alignment", bReadOnly, false);
		updateControl("goals", bReadOnly, false);
		updateControl("obligations", bReadOnly, false);
		updateControl("deity", bReadOnly, false);
		updateControl("adherents", bReadOnly, false);
		updateControl("funding", bReadOnly, false);
		updateControl("status", bReadOnly, false);
		updateControl("gender", bReadOnly, false);
		updateControl("race", bReadOnly, false);
		updateControl("occupation", bReadOnly, false);
		updateControl("faction", bReadOnly, false);
		updateControl("relationships", bReadOnly, false);
		if updateControl("leader", bReadOnly, true) then bSection3 = true; end
		if updateControl("npcs", bReadOnly, true) then bSection3 = true; end
		if updateControl("images", bReadOnly, true) then bSection4 = true; end
		if updateControl("places", bReadOnly, true) then bSection4 = true; end
	elseif sType == "Group" then
		if updateControl("inplace", bReadOnly, true) then bSection1 = true; end
		updateControl("hq", bReadOnly, false)
		if updateControl("description", bReadOnly, true) then bSection1 = true; end
		if updateControl("gmdescription", bReadOnly, true) then bSection1 = true; end
		button_chat_place.setVisible(true);
		if updateControl("pcdescription", bReadOnly, true) then bSection2 = true; end
		if updateControl("placetype", bReadOnly, true) then bSection2 = true; end
		if updateControl("demographics", bReadOnly, true) then bSection2 = true; end
		if updateControl("languages", bReadOnly, true) then bSection2 = true; end
		if updateControl("economy", bReadOnly, true) then bSection2 = true; end
		if updateControl("government", bReadOnly, true) then bSection2 = true; end
		if updateControl("history", bReadOnly, true) then bSection2 = true; end
		if updateControl("religion", bReadOnly, true) then bSection2 = true; end
		updateControl("grouptype", bReadOnly, false);
		updateControl("purpose", bReadOnly, false);
		updateControl("alignment", bReadOnly, false);
		updateControl("goals", bReadOnly, false);
		updateControl("obligations", bReadOnly, false);
		updateControl("deity", bReadOnly, false);
		updateControl("adherents", bReadOnly, false);
		updateControl("funding", bReadOnly, false);
		updateControl("status", bReadOnly, false);
		updateControl("gender", bReadOnly, false);
		updateControl("race", bReadOnly, false);
		updateControl("occupation", bReadOnly, false);
		updateControl("faction", bReadOnly, false);
		updateControl("relationships", bReadOnly, false);
		if updateControl("leader", bReadOnly, true) then bSection3 = true; end
		if updateControl("npcs", bReadOnly, true) then bSection3 = true; end
		if updateControl("images", bReadOnly, true) then bSection4 = true; end
		if updateControl("places", bReadOnly, true) then bSection4 = true; end
	elseif sType == "Entity" then
		if updateControl("inplace", bReadOnly, true) then bSection1 = true; end
		updateControl("hq", bReadOnly, false);
		if updateControl("description", bReadOnly, true) then bSection1 = true; end
		button_chat_place.setVisible(true);
		if updateControl("gmdescription", bReadOnly, true) then bSection1 = true; end
		if updateControl("pcdescription", bReadOnly, true) then bSection2 = true; end
		updateControl("placetype", bReadOnly, false);
		updateControl("demographics", bReadOnly, false);
		updateControl("languages", bReadOnly, false);
		updateControl("economy", bReadOnly, false);
		updateControl("government", bReadOnly, false);
		updateControl("history", bReadOnly, false);
		updateControl("religion", bReadOnly, false);
		updateControl("grouptype", bReadOnly, false);
		updateControl("purpose", bReadOnly, false);
		updateControl("status", bReadOnly, true);
		updateControl("gender", bReadOnly, true);
		updateControl("race", bReadOnly, true);
		updateControl("occupation", bReadOnly, true);
		updateControl("faction", bReadOnly, true);
		updateControl("relationships", bReadOnly, true);
		if updateControl("alignment", bReadOnly, true) then bSection2 = true; end
		if updateControl("goals", bReadOnly, true) then bSection2 = true; end
		updateControl("obligations", bReadOnly, false);
		if updateControl("deity", bReadOnly, false) then bSection2 = true; end
		if updateControl("adherents", bReadOnly, false) then bSection2 = true; end
		if updateControl("funding", bReadOnly, false) then bSection2 = true; end
		if updateControl("leader", bReadOnly, false) then bSection3 = true; end
		if updateControl("npcs", bReadOnly, false) then bSection3 = true; end
		if updateControl("images", bReadOnly, true) then bSection4 = true; end
		if updateControl("places", bReadOnly, false) then bSection4 = true; end

	elseif sType == "Religion" then
		updateControl("inplace", bReadOnly, false);
		if updateControl("hq", bReadOnly, true) then bSection1 = true; end
		if updateControl("description", bReadOnly, true) then bSection1 = true; end
		button_chat_place.setVisible(true);
		if updateControl("gmdescription", bReadOnly, true) then bSection1 = true; end
		if updateControl("pcdescription", bReadOnly, true) then bSection2 = true; end
		updateControl("placetype", bReadOnly, false);
		updateControl("demographics", bReadOnly, false);
		updateControl("languages", bReadOnly, false);
		updateControl("economy", bReadOnly, false);
		updateControl("government", bReadOnly, false);
		if updateControl("history", bReadOnly, true) then bSection2 = true; end
		updateControl("religion", bReadOnly, false);
		updateControl("grouptype", bReadOnly, false);
		updateControl("purpose", bReadOnly, false);
		updateControl("status", bReadOnly, false);
		updateControl("gender", bReadOnly, false);
		updateControl("race", bReadOnly, false);
		updateControl("occupation", bReadOnly, false);
		updateControl("faction", bReadOnly, false);
		updateControl("relationships", bReadOnly, false);
		if updateControl("alignment", bReadOnly, true) then bSection2 = true; end
		if updateControl("goals", bReadOnly, true) then bSection2 = true; end
		updateControl("obligations", bReadOnly, false);
		if updateControl("deity", bReadOnly, true) then bSection2 = true; end
		if updateControl("adherents", bReadOnly, true) then bSection2 = true; end
		if updateControl("funding", bReadOnly, true) then bSection2 = true; end
		if updateControl("leader", bReadOnly, true) then bSection3 = true; end
		if updateControl("npcs", bReadOnly, true) then bSection3 = true; end
		if updateControl("images", bReadOnly, true) then bSection4 = true; end
		if updateControl("places", bReadOnly, true) then bSection4 = true; end

	elseif sType == "Other" then
		updateControl("inplace", bReadOnly, true);
		if updateControl("hq", bReadOnly, false) then bSection1 = true; end
		if updateControl("description", bReadOnly, true) then bSection1 = true; end
		button_chat_place.setVisible(true);
		if updateControl("gmdescription", bReadOnly, true) then bSection1 = true; end
		if updateControl("pcdescription", bReadOnly, true) then bSection2 = true; end
		updateControl("placetype", bReadOnly, true);
		updateControl("demographics", bReadOnly, false);
		updateControl("languages", bReadOnly, false);
		updateControl("economy", bReadOnly, false);
		updateControl("government", bReadOnly, false);
		if updateControl("history", bReadOnly, false) then bSection2 = true; end
		updateControl("religion", bReadOnly, false);
		updateControl("grouptype", bReadOnly, false);
		updateControl("purpose", bReadOnly, false);
		updateControl("status", bReadOnly, false);
		updateControl("gender", bReadOnly, false);
		updateControl("race", bReadOnly, false);
		updateControl("occupation", bReadOnly, false);
		updateControl("faction", bReadOnly, false);
		updateControl("relationships", bReadOnly, false);
		if updateControl("alignment", bReadOnly, true) then bSection2 = true; end
		if updateControl("goals", bReadOnly, false) then bSection2 = true; end
		updateControl("obligations", bReadOnly, false);
		if updateControl("deity", bReadOnly, false) then bSection2 = true; end
		if updateControl("adherents", bReadOnly, false) then bSection2 = true; end
		if updateControl("funding", bReadOnly, false) then bSection2 = true; end
		if updateControl("leader", bReadOnly, false) then bSection3 = true; end
		if updateControl("npcs", bReadOnly, true) then bSection3 = true; end
		if updateControl("images", bReadOnly, true) then bSection4 = true; end
		if updateControl("places", bReadOnly, true) then bSection4 = true; end


	end

	worldtype.setReadOnly(bReadOnly);
	divider1.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);

	if not User.isHost() then
		gmdescription_label.setVisible(false);
		-- inplace
		-- inplace.setVisible(false);
		if inplace_enabled.getValue() == 1 then 
			inplace_label.setVisible(true);
			inplace.setVisible(true);
			inplace_enabled.setVisible(false);
		else
			inplace_label.setVisible(false);
			inplace.setVisible(false);
			inplace_enabled.setVisible(false);
		end
		-- description
		-- description.setVisible(false);
		if description_enabled.getValue() == 1 then 
			description_label.setVisible(true);
			description.setVisible(true);
			description_enabled.setVisible(false);
		else
			description_label.setVisible(false);
			description.setVisible(false);
			description_enabled.setVisible(false);
		end
		-- status
		-- status.setVisible(false);
		if status_enabled.getValue() == 1 then 
			status_label.setVisible(true);
			status.setVisible(true);
			status_enabled.setVisible(false);
		else
			status_label.setVisible(false);
			status.setVisible(false);
			status_enabled.setVisible(false);
		end
		-- gender
		-- gender.setVisible(false);
		if gender_enabled.getValue() == 1 then 
			gender_label.setVisible(true);
			gender.setVisible(true);
			gender_enabled.setVisible(false);
		else
			gender_label.setVisible(false);
			gender.setVisible(false);
			gender_enabled.setVisible(false);
		end
		-- race
		-- race.setVisible(false);
		if race_enabled.getValue() == 1 then 
			race_label.setVisible(true);
			race.setVisible(true);
			race_enabled.setVisible(false);
		else
			race_label.setVisible(false);
			race.setVisible(false);
			race_enabled.setVisible(false);
		end
		-- occupation
		-- occupation.setVisible(false);
		if occupation_enabled.getValue() == 1 then 
			occupation_label.setVisible(true);
			occupation.setVisible(true);
			occupation_enabled.setVisible(false);
		else
			occupation_label.setVisible(false);
			occupation.setVisible(false);
			occupation_enabled.setVisible(false);
		end
		-- faction
		-- faction.setVisible(false);
		if faction_enabled.getValue() == 1 then 
			faction_label.setVisible(true);
			faction.setVisible(true);
			faction_enabled.setVisible(false);
		else
			faction_label.setVisible(false);
			faction.setVisible(false);
			faction_enabled.setVisible(false);
		end
		-- relationships
		-- relationships.setVisible(false);
		if relationships_enabled.getValue() == 1 then 
			relationships_label.setVisible(true);
			relationships.setVisible(true);
			relationships_enabled.setVisible(false);
		else
			relationships_label.setVisible(false);
			relationships.setVisible(false);
			relationships_enabled.setVisible(false);
		end
		
		-- hq
		-- hq.setVisible(false);
		if hq_enabled.getValue() == 1 then 
			hq_label.setVisible(true);
			hq.setVisible(true);
			hq_enabled.setVisible(false);
		else
			hq_label.setVisible(false);
			hq.setVisible(false);
			hq_enabled.setVisible(false);
		end
		button_chat_place.setVisible(false);
		gmdescription.setVisible(false);
		-- placetype
		-- placetype.setVisible(false);
		if placetype_enabled.getValue() == 1 then 
			placetype_label.setVisible(true);
			placetype.setVisible(true);
			placetype_enabled.setVisible(false);
		else
			placetype_label.setVisible(false);
			placetype.setVisible(false);
			placetype_enabled.setVisible(false);
		end
		-- demographics
		-- demographics.setVisible(false);
		if demographics_enabled.getValue() == 1 then 
			demographics_label.setVisible(true);
			demographics.setVisible(true);
			demographics_enabled.setVisible(false);
		else
			demographics_label.setVisible(false);
			demographics.setVisible(false);
			demographics_enabled.setVisible(false);
		end
		-- placetype
		-- placetype.setVisible(false);
		if placetype_enabled.getValue() == 1 then 
			placetype_label.setVisible(true);
			placetype.setVisible(true);
			placetype_enabled.setVisible(false);
		else
			placetype_label.setVisible(false);
			placetype.setVisible(false);
			placetype_enabled.setVisible(false);
		end
		-- languages
		-- languages.setVisible(false);
		if languages_enabled.getValue() == 1 then 
			languages_label.setVisible(true);
			languages.setVisible(true);
			languages_enabled.setVisible(false);
		else
			languages_label.setVisible(false);
			languages.setVisible(false);
			languages_enabled.setVisible(false);
		end
		-- economy 
		-- economy.setVisible(false);
		if economy_enabled.getValue() == 1 then 
			economy_label.setVisible(true);
			economy.setVisible(true);
			economy_enabled.setVisible(false);
		else
			economy_label.setVisible(false);
			economy.setVisible(false);
			economy_enabled.setVisible(false);
		end
		-- government
		-- government.setVisible(false);
		if government_enabled.getValue() == 1 then 
			government_label.setVisible(true);
			government.setVisible(true);
			government_enabled.setVisible(false);
		else
			government_label.setVisible(false);
			government.setVisible(false);
			government_enabled.setVisible(false);
		end
		-- history
		-- history.setVisible(false);
		if history_enabled.getValue() == 1 then 
			history_label.setVisible(true);
			history.setVisible(true);
			history_enabled.setVisible(false);
		else
			history_label.setVisible(false);
			history.setVisible(false);
			history_enabled.setVisible(false);
		end
		-- religion
		-- religion.setVisible(false);
		if religion_enabled.getValue() == 1 then 
			religion_label.setVisible(true);
			religion.setVisible(true);
			religion_enabled.setVisible(false);
		else
			religion_label.setVisible(false);
			religion.setVisible(false);
			religion_enabled.setVisible(false);
		end
		-- grouptype
		-- grouptype.setVisible(false);
		if grouptype_enabled.getValue() == 1 then 
			grouptype_label.setVisible(true);
			grouptype.setVisible(true);
			grouptype_enabled.setVisible(false);
		else
			grouptype_label.setVisible(false);
			grouptype.setVisible(false);
			grouptype_enabled.setVisible(false);
		end
		-- purpose
		-- purpose.setVisible(false);
		if purpose_enabled.getValue() == 1 then 
			purpose_label.setVisible(true);
			purpose.setVisible(true);
			purpose_enabled.setVisible(false);
		else
			purpose_label.setVisible(false);
			purpose.setVisible(false);
			purpose_enabled.setVisible(false);
		end
		-- alignment
		-- alignment.setVisible(false);
		if alignment_enabled.getValue() == 1 then 
			alignment_label.setVisible(true);
			alignment.setVisible(true);
			alignment_enabled.setVisible(false);
		else
			alignment_label.setVisible(false);
			alignment.setVisible(false);
			alignment_enabled.setVisible(false);
		end
		-- goals
		-- goals.setVisible(false);
		if goals_enabled.getValue() == 1 then 
			goals_label.setVisible(true);
			goals.setVisible(true);
			goals_enabled.setVisible(false);
		else
			goals_label.setVisible(false);
			goals.setVisible(false);
			goals_enabled.setVisible(false);
		end
		-- obligations
		-- obligations.setVisible(false);
		if obligations_enabled.getValue() == 1 then 
			obligations_label.setVisible(true);
			obligations.setVisible(true);
			obligations_enabled.setVisible(false);
		else
			obligations_label.setVisible(false);
			obligations.setVisible(false);
			obligations_enabled.setVisible(false);
		end
		-- deity
		-- deity.setVisible(false);
		if deity_enabled.getValue() == 1 then 
			deity_label.setVisible(true);
			deity.setVisible(true);
			deity_enabled.setVisible(false);
		else
			deity_label.setVisible(false);
			deity.setVisible(false);
			deity_enabled.setVisible(false);
		end
		-- adherents
		-- adherents.setVisible(false);
		if adherents_enabled.getValue() == 1 then 
			adherents_label.setVisible(true);
			adherents.setVisible(true);
			adherents_enabled.setVisible(false);
		else
			adherents_label.setVisible(false);
			adherents.setVisible(false);
			adherents_enabled.setVisible(false);
		end
		-- funding
		-- funding.setVisible(false);
		if funding_enabled.getValue() == 1 then 
			funding_label.setVisible(true);
			funding.setVisible(true);
			funding_enabled.setVisible(false);
		else
			funding_label.setVisible(false);
			funding.setVisible(false);
			funding_enabled.setVisible(false);
		end
		-- leader
		-- leader.setVisible(false);
		if leader_enabled.getValue() == 1 then 
			leader_label.setVisible(true);
			leader.setVisible(true);
			leader_enabled.setVisible(false);
		else
			leader_label.setVisible(false);
			leader.setVisible(false);
			leader_enabled.setVisible(false);
		end
		-- npcs
		-- npcs.setVisible(false);
		if npcs_enabled.getValue() == 1 then 
			npcs_label.setVisible(true);
			npcs.setVisible(true);
			npcs_enabled.setVisible(false);
		else
			npcs_label.setVisible(false);
			npcs.setVisible(false);
			npcs_enabled.setVisible(false);
		end
		-- images
		-- images.setVisible(false);
		if images_enabled.getValue() == 1 then 
			images_label.setVisible(true);
			images.setVisible(true);
			images_enabled.setVisible(false);
		else
			images_label.setVisible(false);
			images.setVisible(false);
			images_enabled.setVisible(false);
		end
		-- places
		-- places.setVisible(false);
		if places_enabled.getValue() == 1 then 
			places_label.setVisible(true);
			places.setVisible(true);
			places_enabled.setVisible(false);
		else
			places_label.setVisible(false);
			places.setVisible(false);
			places_enabled.setVisible(false);
		end

-- pasted to new doc



		divider1.setVisible(false);
		divider2.setVisible(false);
		divider3.setVisible(false);

		end

end
