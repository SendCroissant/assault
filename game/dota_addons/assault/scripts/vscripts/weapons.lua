function Fire(keys)
  local item = keys.ability
  local charges = item:GetCurrentCharges()
  charges = charges - 1
  if charges == 0 then
    item:RemoveSelf()
    return
  end
  item:SetCurrentCharges(charges)
  
  WeaponsCooldown(keys.caster, item:GetCooldown(0))
end

function WeaponsCooldown(hero, cd)
  for itemSlot = 0, 5, 1 do
    local item = hero:GetItemInSlot(itemSlot)
    if item ~= nil then
      item:StartCooldown(cd)
    end
  end
end

function Equip(keys)
  local item = keys.ability
  local sameItem = FindSameItem(keys.caster, item:GetName())
  if sameItem ~= nil then
    local prevCharges = sameItem:GetCurrentCharges()
    local newCharges = prevCharges + item:GetCurrentCharges()
    local maxCapacity = item:GetSpecialValueFor('capacity')
    if newCharges > maxCapacity then
      newCharges = maxCapacity
    end
    sameItem:SetCurrentCharges(newCharges)
    item:RemoveSelf()
  end
  if item.spawner ~= nil then
    item.spawner:Spawn()
    item.spawner = nil
  end
end

function FindSameItem(hero, name)
  for itemSlot = 0, 5, 1 do
    local item = hero:GetItemInSlot(itemSlot)
    if item ~= nil and item:GetName() == name then
      return item
    end
  end
  return nil
end
