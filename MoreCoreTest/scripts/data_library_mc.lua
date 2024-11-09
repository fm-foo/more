-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getItemIsIdentified(vRecord, vDefault)
	return LibraryData.getIDState("item", vRecord, true);
end


function getItemRecordDisplayClass(vNode)
	local sRecordDisplayClass = "item";
	if vNode then
		local sBasePath, sSecondPath = UtilityManager.getDataBaseNodePathSplit(vNode);
		if sBasePath == "reference" then
			if sSecondPath == "equipmentdata" then
				local sTypeLower = StringManager.trim(DB.getValue(DB.getPath(vNode, "type"), ""):lower());
				if sTypeLower == "weapon" then
					sRecordDisplayClass = "reference_weapon";
				elseif sTypeLower == "armor" then
					sRecordDisplayClass = "reference_armor";
				elseif sTypeLower == "mounts and other animals" then
					sRecordDisplayClass = "reference_mountsandotheranimals";
				elseif sTypeLower == "waterborne vehicles" then
					sRecordDisplayClass = "reference_waterbornevehicles";
				elseif sTypeLower == "vehicle" then
					sRecordDisplayClass = "reference_vehicle";
				else
					sRecordDisplayClass = "reference_equipment";
				end
			else
				sRecordDisplayClass = "reference_magicitem";
			end
		end
	end
	return sRecordDisplayClass;
end

function isItemIdentifiable(vNode)
	return (getItemRecordDisplayClass(vNode) == "item");
end


aRecordOverrides = {
	-- CoreRPG overrides
	["quest"] = { 
		aDataMap = { "quest", "reference.questdata" }, 
	},
	["image"] = { 
		aDataMap = { "image", "reference.imagedata" }, 
	},
	["npc"] = { 
		aDataMap = { "npc", "reference.npcdata" }, 
		aGMListButtons = { "button_npc_letter", "button_npc_cr", "button_npc_type" },
		aGMEditButtons = { "button_add_npc_import" },
		aCustomFilters = {
			["CR"] = { sField = "cr", sType = "number", fSort = sortNPCCRValues },
			["Type"] = { sField = "type", fGetValue = getNPCTypeValue },
		},
	},
	["item"] = { 
		fIsIdentifiable = isItemIdentifiable,
		aDataMap = { "item", "reference.equipmentdata", "reference.magicitemdata" }, 
		fRecordDisplayClass = getItemRecordDisplayClass,
		aRecordDisplayClasses = { "item", "reference_magicitem", "reference_armor", "reference_weapon", "reference_equipment", "reference_mountsandotheranimals", "reference_waterbornevehicles", "reference_vehicle" },
		aGMListButtons = { "button_item_armor", "button_item_weapons", "button_item_templates", "button_forge_item" },
		aPlayerListButtons = { "button_item_armor", "button_item_weapons" },
		aCustomFilters = {
			["Type"] = { sField = "type" },
			["Rarity"] = { sField = "rarity", fGetValue = getItemRarityValue },
			["Attunement?"] = { sField = "rarity", fGetValue = getItemAttunementValue },
		},
	},
	
	-- New record types
	["mc_investigator"] = { 
		bExport = true,
		aDataMap = { "mc_investigator", "reference.mc_investigator" }, 
		sRecordDisplayClass = "mc_investigator", 
	},
	["ability"] = {
		bExport = true, 
		aDataMap = { "ability", "reference.ability" }, 
		sRecordDisplayClass = "ability", 
	},
	["pcclass"] = {
		bExport = true, 
		aDataMap = { "pcclass", "reference.pcclass" }, 
		sRecordDisplayClass = "pcclass", 
	},
	["pcrace"] = {
		bExport = true, 
		aDataMap = { "pcrace", "reference.pcrace" }, 
		sRecordDisplayClass = "pcrace", 
	},
	["mc_world"] = {
		bExport = true, 
		aDataMap = { "mc_world", "reference.mc_world" }, 
		sRecordDisplayClass = "mc_world", 
	},
	["cas"] = {
		bExport = true, 
		aDataMap = { "cas", "reference.cas" }, 
		sRecordDisplayClass = "cas", 
	},
};



function onInit()
	LibraryData.setCustomFilterHandler("item_isidentified", getItemIsIdentified);

	LibraryData.overrideRecordTypes(aRecordOverrides);
end
