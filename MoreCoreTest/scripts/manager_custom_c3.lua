-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "c3mod"

local sCmd = "c3mod";

function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
	CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
-- Debug.console("performAction: ", draginfo, rActor, sParams);

	local rRoll = {};
	rRoll.sType = sCmd;
	rRoll.nMod = 0;
----	Debug.chat("sParams: ", sParams);
--	Debug.chat("ActorManager: ", ActorManager.getCTNode(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getActor(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getTypeAndNodeName(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getType(rActor));
	local sc3cost, sc3name = sParams:match("(%-?%d+)%s*(.*)");
--	Debug.chat("sc3cost: ", sc3cost, " sc3name: ", sc3name);
--	Debug.chat("rActor: ", rActor);
	local nodeWin = rActor.sCreatureNode;
--	Debug.chat("nodeWin: ", nodeWin, " sc3name: ", sc3name);
	local sName = rActor.sName;
	local sModDesc, nMod = ModifierStack.getStack(true);
	--	Debug.chat("sModDesc: ", sModDesc);
	--	Debug.chat("nMod: ", nMod);
	local nTotalCost = tonumber(sc3cost) + nMod;
	--	Debug.chat("nTotalCost: ", nTotalCost);

	rRoll.sDesc = sc3name;
	rRoll.nTotalCost = nTotalCost;
	rRoll.sModDesc = sModDesc;
----	Debug.chat("rRoll: ", rRoll);

--	Debug.console("performAction: ", rRoll);
 
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- display total


--	local nSpellMax = tonumber(DB.getValue(nodeWin .. ".wounds"));
----	Debug.chat("nSpellMax: ", nSpellMax);
----	Debug.chat("nodeWin: ", nodeWin);

		nc3Cur = DB.getValue(nodeWin .. ".wounds");
	--	Debug.chat("PC nc3Cur: ", nc3Cur);
	
		rMessage.text = sName .. " uses " .. rMessage.text .. " " .. rRoll.sModDesc .. " (cost " .. nTotalCost .. ")";
		nc3Cur = nc3Cur + nTotalCost;
--	--	Debug.chat("nc3Cur: ", tonumber(nc3Cur)); 

		DB.setValue(nodeWin .. ".wounds", "number", tonumber(nc3Cur));
	--	Debug.chat("PC nc3Cur SET: ", nc3Cur);

		DB.setValue(nodeWin .. ".wounds", "number", tonumber(nc3Cur));

	rMessage.text = rMessage.text .. rRoll.sModDesc;
	Comm.deliverChatMessage(rMessage);
	end   

