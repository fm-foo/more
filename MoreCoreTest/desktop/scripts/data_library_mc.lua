-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

aRecords = {
	["mc_investigator"] = { 
		bNoCategories = true,
		sEditMode = "play",
		aDataMap = { "mc_investigator", "reference.mc_investigator" }, 
		aDisplayIcon = { "button_investigator", "button_investigator_down" },
		sListDisplayClass = "masterindexitem_investigator",
		-- sRecordDisplayClass = "note", 
	},
	["ability"] = { 
		bExport = true,
		sEditMode = "play",
		aDataMap = { "ability", "reference.ability" }, 
		aDisplayIcon = { "button_mcability", "button_mcability_down" },
		-- sListDisplayClass = "ability",
	},	
	["pcclass"] = { 
		bExport = true,
		sEditMode = "play",
		aDataMap = { "pcclass", "reference.pcclass" }, 
		aDisplayIcon = { "button_pcclass", "button_pcclass_down" },
		sRecordDisplayClass = "pcclass", 
		},
	["pcrace"] = { 
		bExport = true,
		sEditMode = "play",
		aDataMap = { "pcrace", "reference.pcrace" }, 
		aDisplayIcon = { "button_pcrace", "button_pcrace_down" },
		sRecordDisplayClass = "pcrace", 
		},
	["mc_world"] = { 
		bExport = true,
		sEditMode = "play",
		aDataMap = { "mc_world", "reference.mc_world" }, 
		aDisplayIcon = { "button_world", "button_world_down" },
		sRecordDisplayClass = "mc_world", 
		},
	["cas"] = { 
		bExport = true,
		sEditMode = "play",
		aDataMap = { "cas", "reference.cas" }, 
		aDisplayIcon = { "button_cas", "button_cas_down" },
		-- sListDisplayClass = "cas",
		-- sRecordDisplayClass = "note", 
	},
};
aDefaultSidebarState = {
	["gm"] = "charsheet,note,image,table,story,quest,npc,battle,item,cas,mc_world",
	["play"] = "charsheet,note,image,story,npc,item,cas,trackers,pcclass,spells",
	["create"] = "charsheet,cas,trackers,pcclass,pcrace,item,spells"
};


function onInit()
	for kDefSidebar,vDefSidebar in pairs(aDefaultSidebarState) do
		DesktopManager.setDefaultSidebarState(kDefSidebar, vDefSidebar);
	end

	for kRecordType,vRecordType in pairs(aRecords) do
		LibraryData.setRecordTypeInfo(kRecordType, vRecordType);
	end

--	DesktopManager.showDockTitleText(true);
--	DesktopManager.setDockTitleFont("sidebar");
--	DesktopManager.setDockTitleFrame("", 25, 2, 25, 5);
--	DesktopManager.setDockTitlePosition("top", 2, 14);
	DesktopManager.setStackIconSizeAndSpacing(47, 27, 3, 3, 4, 0);
--	DesktopManager.setDockIconSizeAndSpacing(100, 30, 0, 2);
--	DesktopManager.setLowerDockOffset(2, 0, 2, 3);
end


function unusedDatatypes()
-- not a real function

aUnusedRecords = {
	["mc_locations"] = { 
		sEditMode = "play",
		aDataMap = { "mc_locations", "reference.mc_locations" }, 
		aDisplayIcon = { "button_mc_locations", "button_mc_locations_down" },
		sListDisplayClass = "mc_locations",
		-- sRecordDisplayClass = "note", 
	},
	["mc_organisations"] = { 
		sEditMode = "play",
		aDataMap = { "mc_organisations", "reference.mc_organisations" }, 
		aDisplayIcon = { "button_mc_organisations", "button_mc_organisations_down" },
		sListDisplayClass = "mc_organisations",
	},
	}
LibraryData.setRecordTypeInfo("trackers", {
sDisplayText = "library_recordtype_label_trackers",
aDataMap = { "trackers", "reference.trackers" },
aDisplayIcon = { "button_trackers", "button_trackers_down" },
fToggleIndex = toggleCharRecordIndex,
sRecordDisplayClass = "trackers",
});

-- not a real function
LibraryData.setRecordTypeInfo("spells", {
sDisplayText = "library_recordtype_label_spells",
aDataMap = { "spells", "reference.spells" },
aDisplayIcon = { "button_spells", "button_spells_down" },
fToggleIndex = toggleCharRecordIndex,
sRecordDisplayClass = "spells",
});

end

function buildDesktop()
	-- Local mode
	if User.isLocal() then
		DesktopManager.registerStackShortcutMC("button_color", "button_color_down", "sidebar_tooltip_colors", "pointerselection");

		DesktopManager.registerDockShortcut2("button_characters", "button_characters_down", "sidebar_tooltip_character", "charselect_client");
		DesktopManager.registerDockShortcut2("button_library", "button_library_down", "sidebar_tooltip_library", "library");

	-- GM mode
	elseif User.isHost() then
		DesktopManager.registerStackShortcutMC("button_ct", "button_ct_down", "sidebar_tooltip_ct", "combattracker_host", "combattracker");
		DesktopManager.registerStackShortcutMC("button_partysheet", "button_partysheet_down", "sidebar_tooltip_ps", "partysheet_host", "partysheet");

		DesktopManager.registerStackShortcutMC("button_calendar", "button_calendar_down", "sidebar_tooltip_calendar", "calendar", "calendar");
		DesktopManager.registerStackShortcutMC("button_color", "button_color_down", "sidebar_tooltip_colors", "pointerselection");

		DesktopManager.registerStackShortcutMC("button_light", "button_light_down", "sidebar_tooltip_lighting", "lightingselection");
		DesktopManager.registerStackShortcutMC("button_options", "button_options_down", "sidebar_tooltip_options", "options");

		DesktopManager.registerStackShortcutMC("button_modifiers", "button_modifiers_down", "sidebar_tooltip_modifiers", "modifiers", "modifiers");
		DesktopManager.registerStackShortcutMC("button_effects", "button_effects_down", "sidebar_tooltip_effects", "effectlist", "effects");

		DesktopManager.registerDockShortcut2("button_characters", "button_characters_down", "sidebar_tooltip_character", "charselect_host", "charsheet");
		DesktopManager.registerDockShortcut2("button_book", "button_book_down", "sidebar_tooltip_story", "encounterlist", "encounter");
		DesktopManager.registerDockShortcut2("button_maps", "button_maps_down", "sidebar_tooltip_image", "imagelist", "image");
		DesktopManager.registerDockShortcut2("button_people", "button_people_down", "sidebar_tooltip_npc", "npclist", "npc");
		DesktopManager.registerDockShortcut2("button_items", "button_items_down", "sidebar_tooltip_item", "itemlist", "item");
		DesktopManager.registerDockShortcut2("button_notes", "button_notes_down", "sidebar_tooltip_note", "notelist", "notes");
		DesktopManager.registerDockShortcut2("button_cas", "button_cas_down", "sidebar_tooltip_cas", "caslist", "cas");
		DesktopManager.registerDockShortcut2("button_spells", "button_spells_down", "sidebar_tooltip_spells", "spellslist", "spells");
		DesktopManager.registerDockShortcut2("button_mcability", "button_mcability_down", "sidebar_tooltip_ability", "abilitylist", "ability");
--		DesktopManager.registerDockShortcut2("button_mc_locations", "button_mc_locations_down", "sidebar_tooltip_mc_locations", "mc_locationslist", "mc_locations");
		DesktopManager.registerDockShortcut2("button_mc_world", "button_mc_world_down", "sidebar_tooltip_mc_world", "mc_worldlist", "mc_world");
		DesktopManager.registerDockShortcut2("button_mc_investigator", "button_mc_investigator_down", "sidebar_tooltip_mc_investigator", "masterindexitem_investigator", "mc_investigator");
--		DesktopManager.registerDockShortcut2("button_mc_organisations", "button_mc_organisations_down", "sidebar_tooltip_mc_organisations", "mc_organisationslist", "mc_organisations");
		DesktopManager.registerDockShortcut2("button_pcclass", "button_pcclass_down", "sidebar_tooltip_pcclass", "mc_organisationslist", "pcclass");
		DesktopManager.registerDockShortcut2("button_library", "button_library_down", "sidebar_tooltip_library", "library");

		DesktopManager.registerDockShortcut2("button_tokencase", "button_tokencase_down", "sidebar_tooltip_token", "tokenbag", nil, true);

	-- Player mode
	else
		DesktopManager.registerStackShortcutMC("button_ct", "button_ct_down", "sidebar_tooltip_ct", "combattracker_host", "combattracker");
		DesktopManager.registerStackShortcutMC("button_partysheet", "button_partysheet_down", "sidebar_tooltip_ps", "partysheet_host", "partysheet");

		DesktopManager.registerStackShortcutMC("button_calendar", "button_calendar_down", "sidebar_tooltip_calendar", "calendar", "calendar");
		DesktopManager.registerStackShortcutMC("button_color", "button_color_down", "sidebar_tooltip_colors", "pointerselection");

		DesktopManager.registerStackShortcutMC("button_light", "button_light_down", "sidebar_tooltip_lighting", "lightingselection");
		DesktopManager.registerStackShortcutMC("button_options", "button_options_down", "sidebar_tooltip_options", "options");

		DesktopManager.registerStackShortcutMC("button_modifiers", "button_modifiers_down", "sidebar_tooltip_modifiers", "modifiers", "modifiers");
		DesktopManager.registerStackShortcutMC("button_effects", "button_effects_down", "sidebar_tooltip_effects", "effectlist", "effects");

		DesktopManager.registerDockShortcut2("button_characters", "button_characters_down", "sidebar_tooltip_character", "charselect_client");
		DesktopManager.registerDockShortcut2("button_book", "button_book_down", "sidebar_tooltip_story", "encounterlist", "encounter");
		DesktopManager.registerDockShortcut2("button_maps", "button_maps_down", "sidebar_tooltip_image", "imagelist", "image");
		DesktopManager.registerDockShortcut2("button_people", "button_people_down", "sidebar_tooltip_npc", "npclist", "npc");
		DesktopManager.registerDockShortcut2("button_items", "button_items_down", "sidebar_tooltip_item", "itemlist", "item");
		DesktopManager.registerDockShortcut2("button_notes", "button_notes_down", "sidebar_tooltip_note", "notelist", "notes");
		DesktopManager.registerDockShortcut2("button_library", "button_library_down", "sidebar_tooltip_library", "library");
		DesktopManager.registerDockShortcut2("button_cas", "button_cas_down", "sidebar_tooltip_cas", "caslist", "cas");
		DesktopManager.registerDockShortcut2("button_spells", "button_spells_down", "sidebar_tooltip_spells", "spellslist", "spells");
		DesktopManager.registerDockShortcut2("button_mcability", "button_mcability_down", "sidebar_tooltip_ability", "abilitylist", "ability");
--		DesktopManager.registerDockShortcut2("button_mc_locations", "button_mc_locations_down", "sidebar_tooltip_mc_locations", "mc_locationslist", "mc_locations");
		DesktopManager.registerDockShortcut2("button_mc_world", "button_mc_world_down", "sidebar_tooltip_mc_world", "mc_worldlist", "mc_world");
		DesktopManager.registerDockShortcut2("button_mc_investigator", "button_mc_investigator_down", "sidebar_tooltip_mc_investigator", "masterindexitem_investigator", "mc_investigator");
		DesktopManager.registerDockShortcut2("button_pcclass", "button_pcclass_down", "sidebar_tooltip_pcclass", "pcclasslist", "pcclass");

		DesktopManager.registerDockShortcut2("button_assets", "button_assets_down", "sidebar_tooltip_assets", "pcclasslist", "pcclass");
		DesktopManager.registerDockShortcut2("button_tokencase", "button_tokencase_down", "sidebar_tooltip_token", "tokenbag", nil, true);
	end
end

