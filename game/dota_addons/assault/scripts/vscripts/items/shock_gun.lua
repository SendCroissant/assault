
function Fire(keys)
  local particleName = "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_final_ti5.vpcf"
  local item = keys.ability
  local speed = item:GetSpecialValueFor('speed')
  local caster = keys.caster
  local target = keys.target_points[1]
  local origin = caster:GetOrigin()
  local vel = target - origin
  local len = vel:Length2D()
  local scale = speed/len
  vel = vel * Vector(scale, scale, scale)

  local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
  ParticleManager:SetParticleControl(particle, 0, origin)
  ParticleManager:SetParticleControl(particle, 1, vel)
  ParticleManager:SetParticleControl(particle, 5, Vector(len/speed, 0, 0))
end

function Explosion(keys)
  local caster = keys.caster
  local item = keys.ability
  local radius = item:GetSpecialValueFor('radius')
  local min_dmg = item:GetSpecialValueFor('min_dmg')
  local max_dmg = item:GetSpecialValueFor('max_dmg')
  local point = keys.target_points[1]
  local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
  local target_types = DOTA_UNIT_TARGET_ALL
  local target_flags = DOTA_UNIT_TARGET_FLAG_NONE 
  local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
  
  for _,unit in ipairs(units) do
    local dist = (unit:GetOrigin() - point):Length2D()
    local dmg = min_dmg + (1 - dist/radius)*(max_dmg-min_dmg)
    ApplyDamage({ victim = unit, attacker = caster, damage = dmg, damage_type = DAMAGE_TYPE_PHYSICAL })
  end
end
