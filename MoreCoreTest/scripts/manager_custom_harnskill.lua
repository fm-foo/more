--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local sCmd = "harnskill";
local sCmdVersion = "v1.0.1";
local sCommandParsePattern = "([^%s]+)%s*(.*)";
local sRollParamPattern = "x(%d+)y(%d+)";
local sUsageMessage = "Usage: /"..sCmd.." x#y#\n       Where x = Mastery Level (ML), y = Penalty.";

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
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function onLanded(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	rRoll = getDiceResults(rRoll);
	rMessage = createChatMessage(rSource, rRoll);
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
	local sML, sPenalty = sRollParam:match(sRollParamPattern);
	local masteryLevel = tonumber(sML);
	local penalty = tonumber(sPenalty);
	local rRoll = {};

	rRoll.sType = sCmd;
	rRoll.nMod = 0;
	--rRoll.sUser = User.getUsername();
	  if Interface.getVersion() < 4 then
		rRoll.aDice = {"d100","d10"};
	  else
		rRoll.aDice = {"d100"};	  
	  end
	rRoll.aDropped = {};
	rRoll.sDesc = sDescriptionParam.." (ML "..sML..")";
	rRoll.nMasteryLevel = masteryLevel;
	rRoll.nPenalty = penalty;

	return rRoll;
end

---
--- This function determines the result of the roll. It stores the roll value and
--- the success level into rRoll.aRollTotal and rRoll.aSuccessLevel respectively.
---
function getDiceResults(rRoll)
	nRollTotal = 0;

	for _,v in ipairs(rRoll.aDice) do
		nRollTotal = nRollTotal + v.result;
	end

	rRoll.nRollTotal = nRollTotal;
	rRoll.nEffectiveMasteryLevel = calculateEffectiveMasteryLevel(rRoll);
	rRoll.sSuccessLevel = resolveResultToSuccessLevel(nRollTotal, rRoll.nEffectiveMasteryLevel);

	return rRoll;
end

---
--- This function calculates the effective mastery level for the roll. It uses
--- the supplied penalty as well as any active mods in the modifier box. The
--- function also limits the EML minimum to 5% and the maximum to 95%.
---
function calculateEffectiveMasteryLevel(rRoll)
	local effectiveMasteryLevel = tonumber(rRoll.nMasteryLevel) - tonumber(rRoll.nPenalty);

	effectiveMasteryLevel = effectiveMasteryLevel + rRoll.nMod;
	if effectiveMasteryLevel < 5 then
		effectiveMasteryLevel = 5;
	end
	if effectiveMasteryLevel > 95 then
		effectiveMasteryLevel = 95;
	end

	return effectiveMasteryLevel;
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

	rMessage.text = rMessage.text.."\n[Skill Test at EML "..rRoll.nEffectiveMasteryLevel.."]\n"..rRoll.nRollTotal.." -> ["..rRoll.sSuccessLevel.."]";
	rMessage.dicedisplay = 0; -- don't display total

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
	rMessage.text = rMessage.text.."by supplying the \"/"..sCmd.."\" command with parameters in the format of \"x#y#\", where the number following the ";
	rMessage.text = rMessage.text.."x is the Mastery Level of the skill used and the number following the ";
	rMessage.text = rMessage.text.."y is the applicable penalty. Supply 0 for y if there is no penalty.";
	rMessage.text = rMessage.text.."\n\nNOTE: Values in the modifier box are applied to the EML NOT the dice roll.";

	Comm.deliverChatMessage(rMessage);
end
