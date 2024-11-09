-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "c1mod"

local sCmd = "c1mod";

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
	local sc1cost, sc1name = sParams:match("(%-?%d+)%s*(.*)");
--	Debug.chat("sc1cost: ", sc1cost, " sc1name: ", sc1name);
--	Debug.chat("rActor: ", rActor);
	local nodeWin = rActor.sCreatureNode;
--	Debug.chat("nodeWin: ", nodeWin, " sc1name: ", sc1name);
	local sName = rActor.sName;
	local sModDesc, nMod = ModifierStack.getStack(true);
	--	Debug.chat("sModDesc: ", sModDesc);
	--	Debug.chat("nMod: ", nMod);
	local nTotalCost = tonumber(sc1cost) + nMod;
	--	Debug.chat("nTotalCost: ", nTotalCost);

	rRoll.sDesc = sc1name;
	rRoll.nTotalCost = nTotalCost;
	rRoll.sModDesc = sModDesc;
----	Debug.chat("rRoll: ", rRoll);

--	Debug.console("performAction: ", rRoll);
 
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- display total


--	local nSpellMax = tonumber(DB.getValue(nodeWin .. ".health"));
----	Debug.chat("nSpellMax: ", nSpellMax);
----	Debug.chat("nodeWin: ", nodeWin);

		nc1Cur = DB.getValue(nodeWin .. ".health");
	--	Debug.chat("PC nc1Cur: ", nc1Cur);
	
		rMessage.text = sName .. " uses " .. rMessage.text .. " " .. rRoll.sModDesc .. " (cost " .. nTotalCost .. ")";
		nc1Cur = nc1Cur + nTotalCost;
--	--	Debug.chat("nc1Cur: ", tonumber(nc1Cur)); 

		DB.setValue(nodeWin .. ".health", "number", tonumber(nc1Cur));
	--	Debug.chat("PC nc1Cur SET: ", nc1Cur);

		DB.setValue(nodeWin .. ".health", "number", tonumber(nc1Cur));

	rMessage.text = rMessage.text .. rRoll.sModDesc;
	Comm.deliverChatMessage(rMessage);
	end   



