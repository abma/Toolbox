local C_HEIGHT = 16
local B_HEIGHT = 26

TriggerWindow = Window:Inherit {
    classname = "window",
    clientWidth = 600,
    clientHeight = 250,
    minimumSize = {500,200},
    x = 500,
    y = 300,
    trigger = nil, --required
    _triggerPanel = nil,
}

local this = TriggerWindow 
local inherited = this.inherited

function TriggerWindow:New(obj)
    obj.caption = obj.trigger.name
	local stackTriggerPanel = MakeComponentPanel(nil)
	stackTriggerPanel.y = 10
	local lblTriggerName = Label:New {
		caption = "Trigger name: ",
		right = 100 + 10,
		x = 1,
		parent = stackTriggerPanel,
	}
	local edTriggerName = EditBox:New {
		text = obj.trigger.name,
		right = 1,
		width = 100,
		parent = stackTriggerPanel,
	}
    obj._triggerPanel = StackPanel:New {
        itemMargin = {0, 0, 0, 0},
        x = 1,
        y = 1,
        right = 1,
        autosize = true,
        resizeItems = false,
        padding = {0, 0, 0, 0}
    }
    local btnAddEvent = Button:New {
        caption='Add event',
        width=110,
        x = 1,
        bottom = 1,
        height = B_HEIGHT,
    }
    local btnAddCondition = Button:New {
        caption='Add condition',
        width=120,
        x = 120,
        bottom = 1,
        height = B_HEIGHT,
    }
    local btnAddAction = Button:New {
        caption='Add action',
        width=110,
        x = 250,
        bottom = 1,
        height = B_HEIGHT,
    }
    local btnClose = Button:New {
        caption='Close',
        width=100,
        x = 370,
        bottom = 1,
        height = B_HEIGHT,
    }
    obj.children = {
		stackTriggerPanel,
        ScrollPanel:New {
            x = 1,
            y = 15 + B_HEIGHT,
            right = 5,
            bottom = B_HEIGHT * 2,
            children = {
                obj._triggerPanel,
            },
        },
        btnAddEvent,
        btnAddCondition,
        btnAddAction,
        btnClose,
    }

    obj = inherited.New(self, obj)
    obj:Populate()
    btnClose.OnClick = {
        function() 
			obj.trigger.name = edTriggerName.text
            obj:Dispose() 			
        end
    }

    btnAddEvent.OnClick={function() MakeAddEventWindow(obj.trigger, obj) end}
    btnAddCondition.OnClick={function() MakeAddConditionWindow(obj.trigger, obj) end}
    btnAddAction.OnClick={function() MakeAddActionWindow(obj.trigger, obj) end}
    return obj
end

function TriggerWindow:Populate()
    self._triggerPanel:ClearChildren()
    local eventLabel = Label:New {
        caption = "- Events -",
        height = C_HEIGHT,
        align = 'center',
        parent = self._triggerPanel,
    }
    for i = 1, #self.trigger.events do
        local event = self.trigger.events[i]
        local stackEventPanel = MakeComponentPanel(self._triggerPanel)
        local btnEditEvent = Button:New {
            caption = SCEN_EDIT.model.eventTypes[event.eventTypeName].humanName,
            right = B_HEIGHT + 10,
            x = 1,
            height = B_HEIGHT,
            parent = stackEventPanel,
            OnClick = {function() MakeEditEventWindow(self.trigger, self, event) end}
        }
        local btnRemoveEvent = Button:New {
            caption = "",
			right = 1,
            width = B_HEIGHT,
            height = B_HEIGHT,
            parent = stackEventPanel,
            padding = {0, 0, 0, 0},
            children = {
                Image:New { 
                    tooltip = "Remove event", 
                    file=SCEN_EDIT_IMG_DIR .. "list-remove.png", 
                    height = B_HEIGHT, 
                    width = B_HEIGHT, 
                    margin = {0, 0, 0, 0},
                },
            },
            OnClick = {function() MakeRemoveEventWindow(self.trigger, self, event, i) end}
        }
    end
    local conditionLabel = Label:New {
        caption = "- Conditions -",
        height = C_HEIGHT,
        align = 'center',
        vlign = 'center',
        parent = self._triggerPanel,
    }
    for i = 1, #self.trigger.conditions do
        local condition = self.trigger.conditions[i]
        local stackEventPanel = MakeComponentPanel(self._triggerPanel)
		local conditionHumanName = SCEN_EDIT.humanExpression(condition, "condition")
        local btnEditCondition = Button:New {
            caption = conditionHumanName,
            right = B_HEIGHT + 10,
            x = 1,
            height = B_HEIGHT,
            parent = stackEventPanel,
            OnClick = {function() MakeEditConditionWindow(self.trigger, self, condition) end}
        }
        local btnRemoveCondition = Button:New {
            caption = "",
			right = 1,
            width = B_HEIGHT,
            height = B_HEIGHT,
            parent = stackEventPanel,
            padding = {0, 0, 0, 0},
            children = {
                Image:New { 
                    tooltip = "Remove condition", 
                    file=SCEN_EDIT_IMG_DIR .. "list-remove.png", 
                    height = B_HEIGHT, 
                    width = B_HEIGHT, 
                    margin = {0, 0, 0, 0},
                },
            },
            OnClick = {function() MakeRemoveConditionWindow(self.trigger, self, condition, i) end}
        }
    end
    local actionLabel = Label:New {
        caption = "- Actions -",
        height = C_HEIGHT,
        align = 'center',
        parent = self._triggerPanel,
    }
    for i = 1, #self.trigger.actions do
        local action = self.trigger.actions[i]
        local stackActionPanel = MakeComponentPanel(self._triggerPanel)
		local actionHumanName = SCEN_EDIT.humanExpression(action, "action")
        local btnEditAction = Button:New {
            caption = actionHumanName,
            right = B_HEIGHT + 10,
            x = 1,
            height = B_HEIGHT,
            parent = stackActionPanel,
            OnClick = {function() MakeEditActionWindow(self.trigger, self, action) end}
        }
        local btnRemoveAction = Button:New {
            caption = "",
            right = 1,
            width = B_HEIGHT,
            height = B_HEIGHT,
            parent = stackActionPanel,
            padding = {0, 0, 0, 0},
            children = {
                Image:New { 
                    tooltip = "Remove action", 
                    file= SCEN_EDIT_IMG_DIR .. "list-remove.png", 
                    height = B_HEIGHT, 
                    width = B_HEIGHT, 
                    margin = {0, 0, 0, 0},
                },
            },
            OnClick = {function() MakeRemoveActionWindow(self.trigger, self, action, i) end},
        }
    end
end

