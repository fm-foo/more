--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local sCmd = "harnroll";
local sCmdVersion = "v1.2.0"
local sCommandParsePattern = "([^%s]+)%s*(.*)";
local sRollParamPattern = "x(%d+)y(%d+)z(%d+)code(%d+)";
local sUsageMessage = "Usage: /"..sCmd.." x#y#z#code#\n       Where x = Mastery Level (ML), y = Penalty, z = Variable use value, code = Variable use designator code.";
-- Maps to Combat Panel column names.
local sCOMBATPANELFATIGUE = "health"; -- MoreCore Health combat panel field.
local sCOMBATPANELENCUMBRANCE = "defence"; -- MoreCore Defence combat panel field.
local sCOMBATPANELINJURYTOTAL = "wounds"; -- MoreCore Wounds combat panel field.
local sCOMBATPANELCOMMONPENALTY = "four"; -- MoreCore Four combat panel field.
local sCOMBATPANELPHYSICALPENALTY = "five"; -- MoreCore Five combat panel field.
-- Client Roller group names.
local ROLLERGROUP1 = "clilist1"; -- MoreCore page upper left group.
local ROLLERGROUP2 = "clilist1a"; -- MoreCore page lower left group.
local ROLLERGROUP3 = "clilist2"; -- MoreCore page upper middle group.
local ROLLERGROUP4 = "clilist2a"; -- MoreCore page lower left group.
local ROLLERGROUP5 = "clilist3"; -- MoreCore page upper right group.
local ROLLERGROUP6 = "clilist3a"; -- MoreCore page lower left group.
local ROLLERGROUP7 = "clilist4"; -- MoreData page left group.
local ROLLERGROUP8 = "clilist5"; -- MoreData page right group.
-- Other important names.
local sENCUMBRANCENODE = "encumbrance"; -- Name of encumbrance node holding the load total.
local sTOTALLOAD = "load"; -- Name of field holding total weight carried. Found on Inventory tab.
local sENDURANCENAME = "Endurance"; -- Name of roller instance to use as Endurance attribute.
-- Designator type codes.
local nRESETPENALTYPANEL = 6;
local nUPDATEENCUMBRANCE = 7;
local nAPPLYFATIGUE = 8;
local nATTRIBMULTIPLY = 9;

function onInit()
	CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
end

function performAction(draginfo, rActor, sParams)
	local nStart, nEnd, sRollParam, sDescriptionParam = string.find(sParams, sCommandParsePattern);

	if sParams == "?" or string.lower(sParams) == "help" then
		createHelpMessage();
		return;
	end
	if not properParameterFormat(sRollParam) then
		return;
	end

	local rRoll = createRoll(sRollParam, sDescriptionParam);
	if rRoll.nVariableUseCode == nUPDATEENCUMBRANCE or rRoll.nVariableUseCode == nRESETPENALTYPANEL then
		rRoll.aDice = {};
		rRoll.sDesc = sDescriptionParam;
	end
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function onLanded(rSource, rTarget, rRoll)
	local rCharacterNode = DB.findNode(rSource.sCreatureNode);
	local nVariableUseCode = tonumber(rRoll.nVariableUseCode);
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	if nVariableUseCode == nRESETPENALTYPANEL then
		resetPenalties(rCharacterNode);
	elseif rRoll.nVariableUseCode == nUPDATEENCUMBRANCE then
		local nMultiplier = tonumber(rRoll.sVariableUseValue);
		local nEncumbrance = calculateEncumbrance(rCharacterNode, nMultiplier);
		updatePenalties(rCharacterNode, nEncumbrance, 0);
	elseif nVariableUseCode == nAPPLYFATIGUE then
		local nFatigueToAdd = tonumber(rRoll.sVariableUseValue);
		local nFatigue = calculateFatigue(rCharacterNode, nFatigueToAdd);
		local nEncumbrance = calculateEncumbrance(rCharacterNode, 0);
		updatePenalties(rCharacterNode, nEncumbrance, nFatigue);
	elseif nVariableUseCode == nATTRIBMULTIPLY then
		calculateProxyMasteryLevel(rRoll);
	end

	if nVariableUseCode == nUPDATEENCUMBRANCE or nVariableUseCode == nRESETPENALTYPANEL then
		rMessage.text = rMessage.text;
	else
		calculateDiceResults(rRoll);
		rMessage = createChatMessage(rSource, rRoll);
	end

	rMessage.type = "dice";
	Comm.deliverChatMessage(rMessage);
end

---
--- This function verifies the command parameter is in the expected format.
---
function properParameterFormat(sRollParam)
	if sRollParam == nil then
		ChatManager.SystemMessage(sCmd.." "..sCmdVersion.."\n"..sUsageMessage);
		return false;
	end
	if not sRollParam:match(sRollParamPattern) then
		ChatManager.SystemMessage(sCmd.." "..sCmdVersion.."\n"..sUsageMessage);
		return false;
	end
	return true;
end

---
--- This function creates the roll object based on the parameters sent in.
---
function createRoll(sRollParam, sDescriptionParam)
	local sML, sPenalty, sVariableUseValue, sVariableUseCode= sRollParam:match(sRollParamPattern);
	local rRoll = {};

	rRoll.sType = sCmd;
	rRoll.nMod = 0;
	  if Interface.getVersion() < 4 then
		rRoll.aDice = {"d100","d10"};
	  else
		rRoll.aDice = {"d100"};	  
	  end
	rRoll.aDropped = {};
	rRoll.sDesc = sDescriptionParam.." (ML "..sML..")";
	rRoll.nMasteryLevel = tonumber(sML);
	rRoll.nPenalty = tonumber(sPenalty);
	rRoll.sVariableUseValue = sVariableUseValue;
	rRoll.nVariableUseCode = tonumber(sVariableUseCode);

	return rRoll;
end

function resetPenalties(rCharacterNode)
	rCharacterNode.getChild(sCOMBATPANELFATIGUE).setValue(0);
	rCharacterNode.getChild(sCOMBATPANELENCUMBRANCE).setValue(0);
	rCharacterNode.getChild(sCOMBATPANELCOMMONPENALTY).setValue(0);
	rCharacterNode.getChild(sCOMBATPANELPHYSICALPENALTY).setValue(0);
end

---
--- This function calculates encumbrance based upon fatigue rate.
---
function calculateEncumbrance(rCharacterNode, nMultiplier)
	local nCurrentEncumbrance = rCharacterNode.getChild(sCOMBATPANELENCUMBRANCE).getValue();
	local nEncumbrance  = 0;

	if nMultiplier > 0 then
		nEncumbrance = calculatedFatigueRate(rCharacterNode) * nMultiplier;
	else
		nEncumbrance = nCurrentEncumbrance;
	end

	return nEncumbrance;
end

---
--- This function calculates fatigue.
---
function calculateFatigue(rCharacterNode, nFatigueToAdd)
	local nCurrentFatigue = rCharacterNode.getChild(sCOMBATPANELFATIGUE).getValue();

	nCurrentFatigue = nCurrentFatigue + nFatigueToAdd;

	return nCurrentFatigue;
end

---
--- This function calculates the fatigue rate.
---
function calculatedFatigueRate(rCharacterNode)
	local rEncumbranceNode = rCharacterNode.getChild(sENCUMBRANCENODE);
	local nTotalLoad = rEncumbranceNode.getChild(sTOTALLOAD).getValue();
	local nEndurance = 0;
	
	for k,v in pairs(rCharacterNode.getChild(ROLLERGROUP1).getChildren()) do
		if v.getChild("name").getValue() == sENDURANCENAME then
			nEndurance = v.getChild("p1").getValue();
			break;
		end
	end

	return math.floor(nTotalLoad/nEndurance);
end

---
--- This function calculates and updates the values of injury, fatigue, common penalty total
--- and physical penalty total fields of the Combat Panel on a character sheet.
---
function updatePenalties(rCharacterNode, nEncumbrance, nFatigue)
	local nCTCurrentInjuryPoints = rCharacterNode.getChild(sCOMBATPANELINJURYTOTAL).getValue();
	local nCommonPenalty = 0;
	local nPhysicalPenalty = 0;

	nCommonPenalty = nFatigue + nCTCurrentInjuryPoints;
	nPhysicalPenalty = nEncumbrance + nCommonPenalty;

	rCharacterNode.getChild(sCOMBATPANELFATIGUE).setValue(nFatigue);
	rCharacterNode.getChild(sCOMBATPANELENCUMBRANCE).setValue(nEncumbrance);
	rCharacterNode.getChild(sCOMBATPANELCOMMONPENALTY).setValue(nCommonPenalty);
	rCharacterNode.getChild(sCOMBATPANELPHYSICALPENALTY).setValue(nPhysicalPenalty);
end

---
--- This function calculates a proxy mastery level by multipling the supplied mastery
--- level by the variable use value.
---
function calculateProxyMasteryLevel(rRoll)
	local nMasteryLevel = tonumber(rRoll.nMasteryLevel);
	local nVariableUseValue = tonumber(rRoll.sVariableUseValue);

	if nVariableUseValue > 1 then
		nMasteryLevel = nMasteryLevel * nVariableUseValue;
	end
	rRoll.nMasteryLevel=nMasteryLevel;
end

---
--- This function determines the result of the roll. It stores the roll value and
--- the success level into respective fields of rRoll.
---
function calculateDiceResults(rRoll)
	local nRollTotal = 0;

	for _,v in ipairs(rRoll.aDice) do
		nRollTotal = nRollTotal + v.result;
	end

	rRoll.nRollTotal = nRollTotal;
	rRoll.nEffectiveMasteryLevel = getEffectiveMasteryLevel(rRoll);
	rRoll.sSuccessLevel = resolveResultToSuccessLevel(nRollTotal, rRoll.nEffectiveMasteryLevel);
end

---
--- This function calculates the effective mastery level for the roll. It uses
--- the supplied penalty as well as any active mods in the modifier box. The
--- function also limits the EML minimum to 5% and the maximum to 95%.
---
function getEffectiveMasteryLevel(rRoll)
	local nEffectiveMasteryLevel = tonumber(rRoll.nMasteryLevel);

	nEffectiveMasteryLevel = nEffectiveMasteryLevel - tonumber(rRoll.nPenalty);
	nEffectiveMasteryLevel = nEffectiveMasteryLevel + rRoll.nMod;
	if nEffectiveMasteryLevel < 5 then
		nEffectiveMasteryLevel = 5;
	end
	if nEffectiveMasteryLevel > 95 then
		nEffectiveMasteryLevel = 95;
	end

	return nEffectiveMasteryLevel;
end

---
--- This function resolves the success level for a roll against a specified effective
--- mastery level.
---
function resolveResultToSuccessLevel(nRollResult, nEffectiveMasteryLevel)
	local sSuccessLevel;

	if nRollResult > nEffectiveMasteryLevel then
		if nRollResult % 5 == 0 then
			sSuccessLevel = "Critical Failure";
		elseif nRollResult % 5 ~= 0 then
			sSuccessLevel = "Marginal Failure";
		end
	elseif nRollResult <= nEffectiveMasteryLevel then
		if nRollResult % 5 == 0 then
			sSuccessLevel = "Critical Success";
		elseif nRollResult % 5 ~= 0 then
			sSuccessLevel = "Marginal Success";
		end
	end

	return sSuccessLevel;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	local nVariableUseDesignator = tonumber(rRoll.nVariableUseCode);

	rMessage.text = rMessage.text.."\n[Skill Test at EML "..rRoll.nEffectiveMasteryLevel.."]\n"..rRoll.nRollTotal.." -> ["..rRoll.sSuccessLevel.."]";
	rMessage.dicedisplay = 0; -- don't display total
	if nVariableUseDesignator == nAPPLYFATIGUE then
		rMessage.text = rMessage.text.."\nIncreased Fatigue by "..rRoll.sVariableUseValue;
	end

	return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()
	local rMessage = ChatManager.createBaseMessage(nil, nil);

	rMessage.text = rMessage.text..sCmd.." "..sCmdVersion.."\n"..sUsageMessage.."\n\n"
	rMessage.text = rMessage.text.."The \"/"..sCmd.."\" command is used to determine the success level of a skill used. A 5%/95% minimum/maximum Effective Mastery Level is honoured by this command.\n";
	rMessage.text = rMessage.text.."You must specify the skill Mastery Level and the applicable penalty ";
	rMessage.text = rMessage.text.."by supplying the \"/"..sCmd.."\" command with parameters in the format of \"x#y#z#code#\", where the number following the ";
	rMessage.text = rMessage.text.."x is the Mastery Level of the skill used and the number following the ";
	rMessage.text = rMessage.text.."y is the applicable penalty. Supply 0 for y if there is no penalty. ";
	rMessage.text = rMessage.text.."The z parameter has a variable use designated by the code parameter.";
	rMessage.text = rMessage.text.."\nNOTE: Values in the modifier box are applied to the EML NOT the dice roll.";
	rMessage.text = rMessage.text.."\n\nValid values for the code parameter are:\n";
	rMessage.text = rMessage.text.."  0 = Standard skill roll. The variable value parameter z is not used and must be set to 0.\n";
	rMessage.text = rMessage.text.."  1 - 5 = Reserved for future use.\n";
	rMessage.text = rMessage.text.."  6 = Reset penalty fields of Penalty Panel to 0. All other parameters (x,y,z) must be set to 0.\n";
	rMessage.text = rMessage.text.."  7 = Update the encumbrance and penalty fields. Uses total weight from inventory page and z as a fatigue rate multiplier. Parameters x and y must be set to 0.\n";
	rMessage.text = rMessage.text.."  8 = Apply parameter z as fatigue to be added on use to Fatigue penalty field.\n";
	rMessage.text = rMessage.text.."  9 = Apply parameter z as a multiplier to parameter x. This is used to create a proxy ML for a skill roll.\n";

	Comm.deliverChatMessage(rMessage);
end
